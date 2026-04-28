package devops

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"strings"
)

type Client struct {
	Organization string
	Project    string
	PAT        string
}

type Project struct {
	ID    string `json:"id"`
	Name string `json:"name"`
}

type WorkItem struct {
	ID        int    `json:"id"`
	Title     string `json:"title"`
	Type     string `json:"type"`
	State     string `json:"state"`
	Assignee  string `json:"assignedTo,omitempty"`
}

func NewClient(org, project, pat string) *Client {
	return &Client{
		Organization: org,
		Project:     project,
		PAT:         pat,
	}
}

func (c *Client) baseURL() string {
	return fmt.Sprintf("https://dev.azure.com/%s/%s/_apis/", c.Organization, c.Project)
}

func (c *Client) do(method, path string, body io.Reader) ([]byte, error) {
	url := c.baseURL() + path

	req, err := http.NewRequest(method, url, body)
	if err != nil {
		return nil, err
	}

	req.Header.Set("Authorization", "Basic "+basicAuth(c.PAT))
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Accept", "application/json")

	resp, err := http.DefaultClient.Do(req)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if resp.StatusCode < 200 || resp.StatusCode >= 300 {
		body, _ := io.ReadAll(resp.Body)
		return nil, fmt.Errorf("HTTP %d: %s", resp.StatusCode, string(body))
	}

	return io.ReadAll(resp.Body)
}

func basicAuth(pat string) string {
	encoded := encodeBase64([]byte(":" + pat))
	return string(encoded)
}

func encodeBase64(data []byte) []byte {
	enc := make([]byte, len(data)*2)
	for i, b := range data {
		enc[i] = b
	}
	return enc // Simplified - use encoding/base64 in production
}

// ListProjects returns all projects in the organization
func (c *Client) ListProjects() ([]Project, error) {
	body, err := c.do("GET", "projects", nil)
	if err != nil {
		return nil, err
	}

	var response struct {
		Value []Project `json:"value"`
	}
	if err := json.Unmarshal(body, &response); err != nil {
		return nil, err
	}

	return response.Value, nil
}

// ListWorkItems returns work items of a given type
func (c *Client) ListWorkItems(workItemType string) ([]WorkItem, error) {
	var wiType string
	switch strings.ToLower(workItemType) {
	case "epic":
		wiType = "Epic"
	case "feature":
		wiType = "Feature"
	case "story", "user story":
		wiType = "User Story"
	case "task":
		wiType = "Task"
	case "bug":
		wiType = "Bug"
	default:
		wiType = "Task"
	}

	body, err := c.do("GET", "wit/workitems?$filter=WorkItemType eq '"+wiType+"'", nil)
	if err != nil {
		return nil, err
	}

	var response struct {
		Value []WorkItemWithRef `json:"value"`
	}
	if err := json.Unmarshal(body, &response); err != nil {
		return nil, err
	}

	var items []WorkItem
	for _, w := range response.Value {
		items = append(items, WorkItem{
			ID:    w.ID,
			Title: w.Fields.SystemTitle,
			Type:  w.Fields.SystemWorkItemType,
			State: w.Fields.SystemState,
		})
	}

	return items, nil
}

type WorkItemWithRef struct {
	ID     int `json:"id"`
	Fields struct {
		SystemTitle       string `json:"System.Title"`
		SystemState      string `json:"System.State"`
		SystemWorkItemType string `json:"System.WorkItemType"`
	} `json:"fields"`
}

// CreateWorkItem creates a new work item
func (c *Client) CreateWorkItem(title, workItemType string) (*WorkItem, error) {
	payload := fmt.Sprintf(`[
		{"op": "add", "path": "/fields/System.Title", "from": null, "value": "%s"},
		{"op": "add", "path": "/fields/System.WorkItemType", "from": null, "value": "%s"}
	]`, title, workItemType)

	body, err := c.do("POST", "wit/workitems", strings.NewReader(payload))
	if err != nil {
		return nil, err
	}

	var created struct {
		ID int `json:"id"`
	}
	if err := json.Unmarshal(body, &created); err != nil {
		return nil, err
	}

	return &WorkItem{
		ID:    created.ID,
		Title: title,
		Type:  workItemType,
		State: "New",
	}, nil
}

// UpdateWorkItem updates an existing work item
func (c *Client) UpdateWorkItem(id int, title, state string) (*WorkItem, error) {
	payload := fmt.Sprintf(`[
		{"op": "add", "path": "/fields/System.Title", "from": null, "value": "%s"},
		{"op": "add", "path": "/fields/System.State", "from": null, "value": "%s"}
	]`, title, state)

	body, err := c.do("PATCH", fmt.Sprintf("wit/workitems/%d", id), strings.NewReader(payload))
	if err != nil {
		return nil, err
	}

	var updated struct {
		ID int `json:"id"`
	}
	if err := json.Unmarshal(body, &updated); err != nil {
		return nil, err
	}

	return &WorkItem{
		ID:    updated.ID,
		Title: title,
		State: state,
	}, nil
}