module vrist

import net.urllib
import json

struct Records[T] {
mut:
	records []Record[T]
}

type RecordRequest = Request

struct Record[T] {
mut:
	id int
	fields T @[json: 'fields']
}

pub fn (r Request) records(document string, table string) RecordRequest {
	url := urllib.URL{
		scheme: r.scheme
		host: r.host,
		path: "/api/docs/${document}/tables/${table}/records",
	}

	mut req := RecordRequest{}
	req = r
	req.doc = document
	req.table = table
	req.url = url

	return req
}

pub fn (r RecordRequest) filter[F](filter map[string][]F) RecordRequest {
	query := json.encode(filter)
	mut q := urllib.Values{}
	q.add("filter", query)

	mut req := RecordRequest{}
	req = r
	req.url.raw_query = q.encode()

	return req
}

pub fn (r RecordRequest) list[T]() ![]Record[T] {
	resp := r.send()!
	body := json.decode(Records[T], resp)!

	return body.records
}