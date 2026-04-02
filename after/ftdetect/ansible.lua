vim.filetype.add {
  pattern = {
    ['.*/group_vars/.*%.yml'] = 'yaml.ansible',
    ['.*/group_vars/.*%.yaml'] = 'yaml.ansible',
    ['.*/group_vars/.*/.*%.yml'] = 'yaml.ansible',
    ['.*/group_vars/.*/.*%.yaml'] = 'yaml.ansible',
    ['.*/host_vars/.*%.yml'] = 'yaml.ansible',
    ['.*/host_vars/.*%.yaml'] = 'yaml.ansible',
    ['.*/hosts%.yml'] = 'yaml.ansible',
    ['.*/playbooks/.*%.yml'] = 'yaml.ansible',
    ['.*/playbooks/.*%.yaml'] = 'yaml.ansible',
    ['.*/roles/.*/tasks/.*%.yml'] = 'yaml.ansible',
    ['.*/roles/.*/tasks/.*%.yaml'] = 'yaml.ansible',
    ['.*/roles/.*/handlers/.*%.yml'] = 'yaml.ansible',
    ['.*/roles/.*/handlers/.*%.yaml'] = 'yaml.ansible',
    ['.*/roles/.*/defaults/.*%.yml'] = 'yaml.ansible',
    ['.*/roles/.*/defaults/.*%.yaml'] = 'yaml.ansible',
  },
}
