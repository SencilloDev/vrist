module vrist 

import net.http
import net.urllib
import json

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

pub fn (c Client) get_orgs() ![]Org {
	url := urllib.URL{
		scheme: "https",
		host: c.url,
		path: "/api/orgs"
	}

	resp := c.http_request(http.Method.get, url)!
	orgs := json.decode([]Org, resp)!

	return orgs
}