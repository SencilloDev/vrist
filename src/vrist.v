module vrist

import net.http
import net.urllib

pub struct Client {
	url string
	token string
}

pub fn new_client(url string, token string) Client {
	return Client{
		url: url,
		token: token,
	}
}

fn (c Client) http_request(method http.Method, url urllib.URL) !string {
	h := http.new_header_from_map({http.CommonHeader.authorization: "Bearer ${c.token}"})

	mut http_req := http.Request{
		method: http.Method.get,
		header: h,
		url: url.str(),
	}

	resp := http_req.do()!

	return resp.body
}