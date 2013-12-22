watir Cookbook
==============

Installs the webdriver executables needed by watir. Watir itself is installed with bundle through Teamcity Agents deployment of the code.
Currenty only runs on windows.

Requirements
------------

#### packages
- `teamcity-agent` - Not really needed but you want to have ruby to run watir from the TeamCity tests.

Attributes
----------

#### watir::default
<table>
  <tr>
    <th>http_url</th>
    <th>String</th>
    <th>The url to the zip file containing the executables for the web driver.</th>
    <th>Urls fetched on October 2013.</th>
  </tr>
  <tr>
    <th>path</th>
    <th>String</th>
    <th>The path where the webdriver executables will be stored.</th>
    <th>C:\watir</th>
  </tr>
</table>

Usage
-----
#### watir::default

Just include `watir::recipe` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[watir::ie]",
    "recipe[watir::chrome]"
  ]
}
```
