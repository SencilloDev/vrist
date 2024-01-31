# vrist

Vrist is a Grist client in V.

This is still an alpha, things will most likely change and break.

## Usage

### Get Records

With a Grist table that looks like this:
| Manufacturer |   Model   | Owner |
| -----------  | --------- | ----- |
| Chevy        | Chevelle  | John  |
| Ford         | F-250     | Dan   |


```v
module main

import vrist

struct Vehicle {
	model        string @[json: 'Model']
	owner        []int  @[json: 'Owner']
	manufacturer string @[json: 'Manufacturer']
}

fn main() {
	c := vrist.new_client('docs.getgrist.com', '<your-api-token>')

	vehicles := c.new_request().records('<document-id>', 'Vehicles').list[Vehicle]()!

	println(get_vehicles(vehicles))

}

// get_vehicles takes in Vrist records and returns an array of the type in the record
fn get_vehicles(records []vrist.Record[Vehicle]) []Vehicle {
	return records.map(fn (v vrist.Record[Vehicle]) Vehicle {
		return v.fields
	})
}
```

Vrist also supports using Grist API filters

```v
filter := {
	'Model': ['Chevelle']
}

filtered_vehicles := c
	.new_request()
	.records('<document-id>', 'Vehicles')
	.filter[string](filter)
	.list[Vehicle]()!

println(filtered_vehicles)
```

## Orgs

```v
// list orgs
orgs := c.new_request().orgs().list()!
println(orgs)

// get org information
org := c.new_request().orgs().get('<workspace-id>')!
println(org)

// get user access for org
users := c.new_request().orgs().user_access('<workspace-id>')!
println(users)

// get org workspaces
workspaces := c.new_request().orgs().workspaces('<workspace-id>')!
println(workspaces)
```

## Workspaces

```v
// get workspace information
workspace := c.new_request().workspaces().get('<worspace-id>')!
println(workspace)

// change workspace name
c.new_request().workspaces().update_name('<workspace-id>', 'new name')!

// delete workspace
c.new_request().workspaces().delete('<workspace-id>')
```

## Docs

```v
// get workspace information
workspace := c.new_request().workspaces().get('<workspace-id>')!

// filter workspace docs to get document by name
filtered := workspaces.docs.filter(it.name == 'Vehicles')

// get document from workspace
doc := c.new_request().docs().get(filtered[0].id)!
println(doc)

// update document name
c.new_request().docs().update_name('<document-id>', 'new name')!

//move to new workspace
c.new_request().docs().move('<document-id>', '<workspace-id>')

// delete document
c.new_request().docs().delete(<document-id>)!
```
