# ==============================================================================
# content.hcl — page resources.
# Source: /reference/content/page/ (the reference notes pages are defined in
# content.hcl; the getting-started guide uses pages.hcl — both are valid since
# any *.hcl file in the lab directory is loaded).
# ==============================================================================

# Source: /reference/content/page/ — "Page with Variables"
resource "page" "welcome" {
  title = "Welcome"
  file  = "instructions/welcome.md"

  variables = {
    version  = "v1.2.3"
    api_url  = "https://api.example.com"
    lab_name = "Docs Example Gallery"
  }
}

# Source: /getting-started/code/content-tasks/ — "Create Page Structure"
resource "page" "customize_homepage" {
  title = "Customize Your Web Server"
  file  = "instructions/customize_homepage.md"

  activities = {
    edit_homepage = resource.task.edit_homepage
  }
}

resource "page" "containers" {
  title = "Containers, Storage & Utilities"
  file  = "instructions/containers.md"
}

resource "page" "vm" {
  title = "Virtual Machines"
  file  = "instructions/vm.md"
}

resource "page" "kubernetes" {
  title = "Kubernetes"
  file  = "instructions/kubernetes.md"
}

resource "page" "nomad" {
  title = "Nomad"
  file  = "instructions/nomad.md"
}

# Source: /reference/content/page/ — "Page with Activities"
resource "page" "tasks_deep_dive" {
  title = "Hands-On Practice"
  file  = "instructions/tasks_deep_dive.md"

  activities = {
    create_file    = resource.task.create_file
    service_checks = resource.task.service_checks
  }
}

# Source: /reference/content/quiz/quiz/ — "Usage in Pages"
resource "page" "quiz_page" {
  title = "Knowledge Assessment"
  file  = "instructions/quiz.md"

  activities = {
    docker_basics = resource.quiz.docker_basics
    final_exam    = resource.quiz.final_exam
  }
}

resource "page" "dynamic_values" {
  title = "Dynamic Values & Functions"
  file  = "instructions/dynamic_values.md"

  # Source: /reference/content/page/ — "Variable Substitution" combined with
  # documented functions from /reference/functions/.
  variables = {
    upper_demo   = upper("hello world")
    join_demo    = join(", ", ["apple", "banana", "cherry"])
    format_demo  = format("%s-%02d", "web", 1)
    max_demo     = tostring(max(1, 5, 3))
    encode_demo  = base64_encode("instruqt")
    session_note = "Session values come from system variables"
  }
}

resource "page" "cloud" {
  title = "Cloud Sandboxes"
  file  = "instructions/cloud.md"
}

resource "page" "finish" {
  title = "Finish"
  file  = "instructions/finish.md"
}
