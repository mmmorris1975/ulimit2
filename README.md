ulimit Cookbook
===============
A cookbook to set resource limits via ulimit.

Requirements
------------
Should support any linux platform, but has been tested successfully on:

  - rhel >= 5.0
  - centos >= 5.0
  - ubuntu >= 12.04
  - fedora >= 17.0

Attributes
----------
#### ulimit::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['ulimit']['conf_dir']</tt></td>
    <td>String</td>
    <td>The directory to store the config file in</td>
    <td><tt>/etc/security/limits.d</tt></td>
  </tr>
  <tr>
    <td><tt>['ulimit']['conf_file']</tt></td>
    <td>String</td>
    <td>The file containing the resource limits</td>
    <td><tt>999-chef-ulimit.conf</tt></td>
  </tr>
</table>

Usage
-----
#### ulimit::default
Set attributes in the ulimit/params namespace to set resource limits.  Example values:

    node.set['ulimit']['params']['default']['nofile'] = 2000 # Set hard and soft open file limit to 2000 for all users
    node.set['ulimit']['params']['default']['nproc']['soft'] = 2000 # Set the soft per-user process limit to 2000 for all users
    node.set['ulimit']['params']['root']['nofile']['soft'] = 8000   # Set the soft open file limit to 8000 for the 'root' user
    node.set['ulimit']['params']['root']['nofile']['hard'] = 'unlimited' # Set the hard open file limit to unlimited for the 'root' user
    node.set['ulimit']['params']['@sysadmin']['nproc']['hard'] = 2500  # Set the hard process limit to 2500 for the 'sysadmin' group

Then, just include `ulimit` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[ulimit]"
  ]
}
```

For systems that don't support individual configuration files, meaning they only support settings in the /etc/security/limits.conf, set ulimit/conf\_dir attribute to '/etc/security' and ulimit/conf\_file attribute to 'limits.conf'; or whatever setting is appropriate to your system.

The default ulimit/conf\_file attribute value gives us a reasonable chance of being the last config file applied.  The files are processed according to their ASCII sort order, so there is still room to add more files to be processed after the recipe default file by naming the config file with leading character prefixes (ex. zzz-last.conf).

License and Authors
-------------------
Authors: Michael Morris

License: 3-clause BSD
