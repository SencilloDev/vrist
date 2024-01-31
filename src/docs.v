module vrist

import net.urllib
import net.http
import json

type DocumentRequest = Request

struct Document {
pub:
	id        string
	name      string
	access    string
	is_pinned bool      @[json: 'isPinned']
	url_id    string    @[json: 'urlId']
	workspace Workspace
}

pub fn (r Request) docs() DocumentRequest {
	url := urllib.URL{
		scheme: r.scheme
		host: r.host
		path: '/api/docs'
	}
	mut req := DocumentRequest{}
	req = r
	req.method = http.Method.get
	req.url = url

	return req
}

pub fn (d DocumentRequest) get(id string) !Document {
	mut req := Request{}
	req = d
	req.url.path += '/${id}'

	resp := req.send()!
	return json.decode(Document, resp)!
}

pub fn (d DocumentRequest) update_name(id string, name string) ! {
	mut req := Request{}
	req = d
	req.url.path += '/${id}'
	req.method = http.Method.patch
	req.data = json.encode({
		'name': name
	})

	req.send()!

	return
}

pub fn (d DocumentRequest) delete(id string) ! {
	mut req := Request{}
	req = d
	req.url.path += '/${id}'
	req.method = http.Method.delete

	req.send()!

	return
}

pub fn (d DocumentRequest) move(doc_id string, workspace_id string) ! {
	mut req := Request{}
	req = d
	req.url.path += '/${doc_id}/move'
	req.method = http.Method.patch
	req.data = json.encode({
		'workspace': workspace_id
	})

	req.send()!

	return
}
