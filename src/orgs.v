module vrist

import net.urllib
import net.http
import json

type OrgRequest = Request

pub struct Org {
pub:
	id         int
	name       string
	domain     string
	owner      Owner
	access     string
	created_at string
	updated_at string
}

struct OrgUsers {
	users []OrgUser
}

struct OrgUser {
pub:
	id     int
	name   string
	email  string
	access string
}

pub struct Owner {
pub:
	id      int
	name    string
	picture string
}

pub fn (r Request) orgs() OrgRequest {
	url := urllib.URL{
		scheme: r.scheme
		host: r.host
		path: '/api/orgs'
	}

	mut req := OrgRequest{}
	req = r
	req.method = http.Method.get
	req.url = url

	return req
}

pub fn (o OrgRequest) list() ![]Org {
	resp := o.send()!
	return json.decode([]Org, resp)!
}

pub fn (o OrgRequest) get(id string) !Org {
	mut req := Request{}
	req = o
	req.url.path += '/${id}'

	resp := req.send()!
	return json.decode(Org, resp)!
}

pub fn (o OrgRequest) update_name(id string, name string) ! {
	mut req := Request{}
	req = o
	req.url.path += '/${id}'
	req.method = http.Method.patch
	req.data = json.encode({
		'name': name
	})

	req.send()!
}

pub fn (o OrgRequest) user_access(id string) !OrgUsers {
	mut req := Request{}
	req = o
	req.method = http.Method.get
	req.url.path += '/${id}/access'

	resp := req.send()!
	return json.decode(OrgUsers, resp)!
}

pub fn (o OrgRequest) new_workspace(id string, name string) !string {
	mut req := Request{}
	req = o
	req.method = http.Method.post
	req.url.path += '/${id}/workspaces'
	req.data = json.encode({
		'name': name
	})

	return req.send()!
}

pub fn (o OrgRequest) workspaces(org_id string) ![]Workspace {
	mut req := Request{}
	req = o
	req.method = http.Method.get
	req.url.path += '/${org_id}/workspaces'

	resp := req.send()!
	return json.decode([]Workspace, resp)!
}
