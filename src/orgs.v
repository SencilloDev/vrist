module vrist 

import net.urllib
import net.http
import json

type OrgRequest = Request

pub struct Org {
	id int
	name string
	domain string
	owner Owner
	access string
	created_at string
	updated_at string
}

pub struct Owner {
	id int
	name string
	picture string
}

pub fn (r Request) orgs() OrgRequest {
	url := urllib.URL{
		scheme: r.scheme,
		host: r.host
		path: "/api/orgs"
	}

	mut req := OrgRequest{}
	req = r
	req.method = http.Method.get
	req.url = url

	return req
}

pub fn (o OrgRequest) list() !GristList {
	resp := o.send()!
	body := json.decode([]Org, resp)!

	return body
}


pub fn (o OrgRequest) get(id string) !Org {
	mut req := Request{}
	req = o
	req.url.path += "/${id}"

	resp := req.send()!
	org := json.decode(Org, resp)!

	return org
}