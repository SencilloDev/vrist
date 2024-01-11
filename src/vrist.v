module vrist

import net.http
import net.urllib
import json

pub struct Client {
	url string
	token string
}

pub struct Document {
	id string
}

struct Records[T] {
mut:
	records []Record[T]
}

struct Record[T] {
mut:
	id int
	fields T @[json: 'fields']
}

pub struct Filter[F] {
	values map[string][]F
}

pub fn new_client(url string, token string) Client {
	return Client{
		url: url,
		token: token,
	}
}

pub struct Request[T, F] {
	doc string
	table string
	filter Filter[F]
}

pub fn (c Client) get_records[T, F](req Request[F]) ![]Record[T] {
	query := json.encode(req.filter.values)
	mut q := urllib.Values{}
	q.add("filter", query)

	url := urllib.URL{
		scheme: "https",
		host: c.url,
		path: "/api/docs/${req.doc}/tables/${req.table}/records",
		raw_query: q.encode(),
	}

	h := http.new_header_from_map({http.CommonHeader.authorization: "Bearer ${c.token}"})

	mut conf := http.FetchConfig{
		method: http.Method.get,
		header: h,
		url: url.str(),
	}

	res := http.fetch(conf)!

	a := json.decode(Records[T], res.body)!

	return a.records
}
