vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = {
    '*/host_vars/*.yml',
    '*/host_vars/*.yaml',
    '*/group_vars/*.yml',
    '*/group_vars/*.yaml',
    '*/group_vars/*/*.yml',
    '*/group_vars/*/*.yaml',
    '*/playbook*.yml',
    '*/playbook*.yaml',
    '*/playbooks/*.yml',
    '*/playbooks/*.yaml',
    '*/roles/*/tasks/*.yml',
    '*/roles/*/tasks/*.yaml',
    '*/roles/*/handlers/*.yml',
    '*/roles/*/handlers/*.yaml',
    '*/molecule/*.yml',
    '*/molecule/*.yaml',
    '/home/*/ansible/*.yaml',
    '/home/*/ansible/*.yml',
  },
  callback = function()
    vim.bo.filetype = 'yaml.ansible'
  end,
})
