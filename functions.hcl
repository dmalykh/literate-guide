# ==============================================================================
# functions.hcl — locals and outputs exercising the documented functions.
# Source: /reference/types/local/, /reference/types/output/, /reference/functions/*
# ==============================================================================

# Source: /reference/types/local/ — "Simple Computed Value" (block form
# `local "name" { value = ... }` as documented on the Local reference page).
local "environment_suffix" {
  value = variable.username == "admin" ? "prod" : "dev"
}

# Source: /reference/types/local/ — "Complex String Building"
local "connection_string" {
  value = format("postgresql://%s:%s@%s:%d/%s",
    variable.database_config.username,
    variable.database_config.password,
    "postgres",
    5432,
    variable.database_config.database
  )
}

# Source: /reference/functions/string/ — one documented example per function.
local "string_functions" {
  value = {
    chomp      = chomp("hello world\n")
    format     = format("Hello %s", "world")
    formatlist = formatlist("hello %s", ["alice", "bob", "charlie"])
    indent     = indent(2, "line1\nline2\nline3")
    join       = join(", ", ["apple", "banana", "cherry"])
    lower      = lower("HELLO WORLD")
    regex      = regex("[0-9]+", "abc123def")
    regexall   = regexall("[0-9]+", "abc123def456")
    split      = split(",", "apple,banana,cherry")
    strrev     = strrev("hello")
    substr     = substr("hello world", 0, 5)
    title      = title("hello world")
    trim       = trim("   hello   ")
    trimprefix = trimprefix("helloworld", "hello")
    trimsuffix = trimsuffix("helloworld", "world")
    trimspace  = trimspace("  hello  ")
    upper      = upper("hello world")
  }
}

# Source: /reference/functions/collection/ — one documented example per function.
local "collection_functions" {
  value = {
    chunklist       = chunklist(["a", "b", "c", "d", "e"], 2)
    coalescelist    = coalescelist([], ["a", "b"], ["c", "d"])
    compact         = compact(["a", "", "b", "c"])
    concat          = concat(["a", "b"], ["c", "d"])
    contains        = contains(["a", "b", "c"], "b")
    distinct        = distinct([1, 2, 2, 3, 1, 4])
    element         = element(["a", "b", "c"], 1)
    flatten         = flatten([["a", "b"], ["c"]])
    keys            = keys({ a = 1, b = 2, c = 3 })
    length          = length([1, 2, 3])
    merge           = merge({ a = 1 }, { b = 2 })
    range           = range(3)
    reverse         = reverse([1, 2, 3])
    setintersection = setintersection([1, 2, 3], [2, 3, 4])
    setproduct      = setproduct(["a", "b"], [1, 2])
    setsubtract     = setsubtract([1, 2, 3], [2, 3])
    setunion        = setunion([1, 2], [2, 3])
    slice           = slice(["a", "b", "c", "d"], 1, 3)
    sort            = sort(["banana", "apple", "cherry"])
    values          = values({ a = 1, b = 2, c = 3 })
    zipmap          = zipmap(["a", "b", "c"], [1, 2, 3])
  }
}

# Source: /reference/functions/numeric/ — one documented example per function.
local "numeric_functions" {
  value = {
    abs      = abs(-10.5)
    ceil     = ceil(10.1)
    floor    = floor(10.9)
    log      = log(16, 2)
    max      = max(1, 5, 3)
    min      = min(1, 5, 3)
    parseint = parseint("FF", 16)
    pow      = pow(2, 3)
    signum   = signum(-42)
  }
}

# Source: /reference/functions/encoding/ — documented examples.
local "encoding_functions" {
  value = {
    jsonencode = jsonencode({ name = "lab", port = 8080 })
    jsondecode = jsondecode("{\"name\": \"lab\", \"port\": 8080}")
    csvdecode  = csvdecode("name,age\nAlice,30\nBob,25")
  }
}

# Source: /reference/functions/lab-environment/ — documented examples
# (base64_encode / base64_decode / system / jumppad / docker_host / docker_ip).
local "environment_functions" {
  value = {
    base64_encode = base64_encode("instruqt")
    base64_decode = base64_decode("aW5zdHJ1cXQ=")
    system_os     = system("os")
    system_arch   = system("arch")
    jumppad       = jumppad()
    docker_host   = docker_host()
    docker_ip     = docker_ip()
  }
}

# Source: /reference/functions/datetime/ — documented examples.
local "datetime_functions" {
  value = {
    formatdate = formatdate("YYYY-MM-DD", "2024-01-15T10:30:00Z")
    timeadd    = timeadd("2024-01-15T10:00:00Z", "1h")
  }
}

# Source: /reference/functions/filesystem/ — documented examples (file/dir/env/home).
local "filesystem_functions" {
  value = {
    file_contents = file("./files/html/index.html")
    dir           = dir()
    env_home      = env("HOME")
    home          = home()
  }
}

# ------------------------------------------------------------------------------
# Outputs
# ------------------------------------------------------------------------------

# Source: /reference/types/output/ — "Simple Value Output"
# NOTE (docs finding): the docs example reads .meta.name, but `meta` has no
# field "name" — the computed container_name field is used instead.
output "web_container_name" {
  value       = resource.container.webserver.container_name
  description = "Name of the web container"
}

# Source: /reference/types/output/ — "Complex Object Output"
output "database_connection" {
  value = {
    host     = "postgres"
    port     = 5432
    database = "myapp"
    username = variable.database_config.username
  }
  description = "Database connection information for applications"
}

# Source: /reference/sandbox/utilities/http/ — "Simple GET Request"
output "api_status" {
  value = resource.http.api_check.status
}

# Source: /reference/sandbox/utilities/http/ — "POST with JSON Payload"
output "created_user" {
  value = jsondecode(resource.http.create_user.body)
}

# Source: /reference/sandbox/utilities/exec/ — "Output Variables"
output "setup_status" {
  value = resource.exec.local_setup.output.STATUS
}

# Source: /reference/sandbox/utilities/random/randomid/ — "Multiple Format Usage"
output "key_base64" {
  value       = resource.random_id.session.base64
  description = "Application key in base64 format"
}

output "key_hex" {
  value       = resource.random_id.session.hex
  description = "Application key in hex format"
}

output "key_decimal" {
  value       = resource.random_id.session.dec
  description = "Application key in decimal format"
}

# Source: /reference/sandbox/utilities/random/randomnumber/ — "Random Port Number"
output "assigned_port" {
  value = resource.random_number.port.value
}

# Source: /reference/sandbox/utilities/random/randomuuid/ — "Simple UUID Generation"
output "session_uuid" {
  value = resource.random_uuid.session_id.value
}

# Source: /reference/sandbox/utilities/random/randomcreature/ — "Simple Creature Name"
output "friendly_name" {
  value = resource.random_creature.lab_id.value
}

# Source: /reference/sandbox/utilities/random/randompassword/ — "Sensitive Values"
output "database_password" {
  value     = resource.random_password.db_password.value
  sensitive = true
}

# Source: /reference/sandbox/certificates/cert/certificateca/ — "Simple CA Certificate"
output "ca_cert_path" {
  value = resource.certificate_ca.root.certificate.path
}

output "ca_key_path" {
  value = resource.certificate_ca.root.private_key.path
}

# Source: /reference/sandbox/certificates/cert/certificateleaf/ — "Simple Server Certificate"
output "server_cert_path" {
  value = resource.certificate_leaf.server.certificate.path
}

# Source: /reference/sandbox/utilities/terraform/ — "Using Terraform Outputs in
# Other Resources" (surfaced as a lab output).
output "terraform_instance_count" {
  value = resource.terraform.example.output.instance_count_out
}

# Function showcase outputs, built from the locals above.
output "string_functions" {
  value = local.string_functions
}

output "collection_functions" {
  value = local.collection_functions
}

output "numeric_functions" {
  value = local.numeric_functions
}

output "encoding_functions" {
  value = local.encoding_functions
}

output "environment_functions" {
  value = local.environment_functions
}

output "datetime_functions" {
  value = local.datetime_functions
}

output "filesystem_functions" {
  value = local.filesystem_functions
}

output "environment_suffix" {
  value = local.environment_suffix
}

output "connection_string" {
  value = local.connection_string
}
