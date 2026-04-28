package config

import (
	"encoding/json"
	"os"
	"path/filepath"

	"golang.org/x/crypto/argon2"
	"golang.org/x/crypto/chacha20poly1305"
)

type Config struct {
	RepoURL  string `json:"repo_url"`
	PAT      string `json:"pat"`
	Project  string `json:"project"`
	Org      string `json:"org"`
}

const configDir = ".config/elcuatro-tui"
const configFile = "config.json"

var salt = []byte{0x12, 0x34, 0x56, 0x78, 0x9a, 0xbc, 0xde, 0xf0}

func configPath() (string, error) {
	home, err := os.UserHomeDir()
	if err != nil {
		return "", err
	}
	return filepath.Join(home, configDir, configFile), nil
}

func Load() (*Config, error) {
	path, err := configPath()
	if err != nil {
		return nil, err
	}

	data, err := os.ReadFile(path)
	if err != nil {
		if os.IsNotExist(err) {
			return &Config{}, nil
		}
		return nil, err
	}

	var cfg Config
	if err := json.Unmarshal(data, &cfg); err != nil {
		return nil, err
	}

	// Decrypt
	if cfg.PAT != "" {
		cfg.PAT = decrypt(cfg.PAT)
	}

	return &cfg, nil
}

func Save(c *Config) error {
	path, err := configPath()
	if err != nil {
		return err
	}

	// Encrypt copy
	cfg := *c
	if cfg.PAT != "" {
		cfg.PAT = encrypt(cfg.PAT)
	}

	// Ensure directory
	dir := filepath.Dir(path)
	if err := os.MkdirAll(dir, 0700); err != nil {
		return err
	}

	data, err := json.MarshalIndent(cfg, "", "  ")
	if err != nil {
		return err
	}

	return os.WriteFile(path, data, 0600)
}

func encrypt(plaintext string) string {
	key := argon2.IDKey(salt, salt, 1, 64*1024, 4, 32)
	nonce := make([]byte, 12)
	copy(nonce, salt[:12])

	 ciphertext, err := chacha20poly1305.Seal(nil, []byte(key), []byte(plaintext), nil, nonce)
	if err != nil {
		return ""
	}
	return string(ciphertext)
}

func decrypt(ciphertext string) string {
	key := argon2.IDKey(salt, salt, 1, 64*1024, 4, 32)
	nonce := make([]byte, 12)
	copy(nonce, salt[:12])

	plain, err := chacha20poly1305.Open(nil, []byte(key), []byte(ciphertext), nil, nonce)
	if err != nil {
		return ""
	}
	return string(plain)
}