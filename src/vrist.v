module vrist

import net.http
import net.urllib

type GristList = []Org

pub struct Client {
	scheme string
	url string
	token string
}

struct Request {
	scheme string
	host string
	token string
mut:	
	method http.Method
	url urllib.URL
	doc string
	table string
	data string
}

pub fn new_client(url string, token string) Client {
	return Client{
		scheme: "https",
		url: url,
		token: token,
	}
}

pub fn (c Client) new_request() Request {
	return Request{
		scheme: c.scheme,
		host: c.url,
		token: c.token,
	}
}

fn (r Request) send() !string {
	h := http.new_header_from_map({http.CommonHeader.authorization: "Bearer ${r.token}"})

	mut http_req := http.Request{
		method: r.method,
		header: h,
		url: r.url.str(),
		data: r.data,
	}

	resp := http_req.do()!

	return resp.body
}