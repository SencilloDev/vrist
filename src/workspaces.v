module vrist

import net.urllib
import net.http
import json

type WorkspaceRequest = Request

pub struct Workspace {
pub:
	id         int
	name       string
	access     string
	docs       []Document
	org_domain string     @[json: 'org_domain']
	org        Org
}

pub fn (r Request) workspaces() WorkspaceRequest {
	url := urllib.URL{
		scheme: r.scheme
		host: r.host
		path: '/api/workspaces'
	}
	mut req := WorkspaceRequest{}
	req = r
	req.method = http.Method.get
	req.url = url

	return req
}

pub fn (w WorkspaceRequest) get(id string) !Workspace {
	mut req := Request{}
	req = w
	req.url.path += '/${id}'

	resp := req.send()!
	return json.decode(Workspace, resp)!
}

pub fn (w WorkspaceRequest) update_name(id string, name string) ! {
	mut req := Request{}
	req = w
	req.url.path += '/${id}'
	req.method = http.Method.patch
	req.data = json.encode({
		'name': name
	})

	req.send()!

	return
}

pub fn (w WorkspaceRequest) delete(id string) ! {
	mut req := Request{}
	req = w
	req.url.path += '/${id}'
	req.method = http.Method.delete

	req.send()!

	return
}
