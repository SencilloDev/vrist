module vrist

import net.http
import net.urllib
import json

struct Records[T] {
mut:
	records []Record[T]
}

struct Record[T] {
mut:
	id int
	fields T @[json: 'fields']
}

pub struct Request {
	doc string
	table string
}

pub fn (c Client) get_records[T](req Request) ![]Record[T] {
	url := urllib.URL{
		scheme: "https",
		host: c.url,
		path: "/api/docs/${req.doc}/tables/${req.table}/records",
	}

	resp := c.http_request(http.Method.get, url)!
	body := json.decode(Records[T], resp)!

	return body.records	
}

pub fn (c Client) get_filtered_records[T, F](req Request, filter map[string][]F) ![]Record[T] {
	query := json.encode(filter)
	mut q := urllib.Values{}
	q.add("filter", query)

	url := urllib.URL{
		scheme: "https",
		host: c.url,
		path: "/api/docs/${req.doc}/tables/${req.table}/records",
		raw_query: q.encode()
	}

	resp := c.http_request(http.Method.get, url)!
	body := json.decode(Records[T], resp)!

	return body.records	
}