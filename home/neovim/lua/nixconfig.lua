local path = vim.fn.stdpath('config') + '/config.json'
return vim.fn.decode_json(vim.fn.readfile(path))
