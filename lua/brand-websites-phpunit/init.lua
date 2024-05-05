local runner = {
    brand = 'all'
}

function runner:set_brand(brand)
    if brand then
        self.brand = brand

        self.run_tests(self)
    else
        self.brand = vim.fn.select(runner:get_brands(), {
            prompt = "Enter brand (default: all): "
        }, function()
            self.run_tests(self)
        end)
        if self.brand == '' then
            self.brand = 'all'
        end
    end
end

function runner:get_brands()
    local handle = io.popen("ls /var/www/html/brand-websites/bin | grep phpunit")
    local result = handle:read("*a")
    handle:close()
    local brands = {}
    for brand in result:gmatch("%S+") do
        table.insert(brands, brand:gsub('phpunit-', ''))
    end
    return brands
end

function runner:run_tests()
    local filename = vim.fn.expand('%:t')
    local command = "bin/phpunit-" .. self.brand .. " --filter " .. filename .. " --testdox"
    os.execute(command)
end

return runner
