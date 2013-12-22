teamcity-agent Cookbook
=======================

Installs teamcity agent

Requirements
------------

#### packages
- `windows` - teamcity-agent needs windows if run on a windows computer

Attributes
----------

#### teamcity-agent::default
<table>
  <tr>
    <th>agent_name</th>
    <th>String</th>
    <th>Name of the teamcity agent</th>
    <th>agent-1</th>
  </tr>
  <tr>
    <th>agent_path</th>
    <th>String</th>
    <th>The path where the teamcity agent will be installed</th>
    <th>c:\tc</th>
  </tr>
  <tr>
    <th>java-path</th>
    <th>String</th>
    <th>The final path to a working java executable on the host</th>
    <th>none</th>
  </tr>
</table>

Usage
-----
#### teamcity-agent::default

Just include `teamcity-agent` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[teamcity-agent]"
  ]
}
```
