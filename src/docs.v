module vrist 

struct Document {
	id int 
	name string 
	access string 
	is_pinned bool @[json: "isPinned"]
}