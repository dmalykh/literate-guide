# ==============================================================================
# tasks.hcl — interactive tasks.
# ==============================================================================

# Source: /getting-started/code/content-tasks/ — "Create Your First Interactive Task"
resource "task" "edit_homepage" {
  description = "Customize the nginx homepage with your own message"

  config {
    target = resource.container.webserver
  }

  condition "file_modified" {
    description = "Customize the nginx homepage with your own message"

    check {
      script          = "scripts/check_homepage.sh"
      failure_message = "Please edit /usr/share/nginx/html/index.html with your custom message"
    }

    solve {
      script = "scripts/solve_homepage.sh"
    }
  }
}

# Source: /reference/content/task/ — "Simple File Creation Task"
resource "task" "create_file" {
  description = "Create a configuration file"

  config {
    target = resource.container.workstation
  }

  condition "file_exists" {
    description = "Create /etc/myapp.conf"

    check {
      script = "scripts/task/create_file/check_config_file.sh"
    }

    solve {
      script = "scripts/task/create_file/create_config_file.sh"
    }
  }
}

# Source: /reference/content/task/ — "Parallel Execution Task", combined with the
# full-syntax features (success_message, config overrides, environment, setup /
# solve / cleanup scripts, per-script timeout override) from "Full Syntax".
resource "task" "service_checks" {
  description     = "Run multiple parallel validations"
  success_message = "Excellent! You've completed all requirements."

  config {
    target            = resource.container.workstation
    user              = "root"
    group             = "root"
    working_directory = "/root"
    timeout           = "30s"

    environment = {
      MARKER_DIR = "/tmp"
    }

    success_exit_codes = [0]

    parallel_exec {
      check = true # Run all check scripts in parallel
    }
  }

  condition "check_service_a" {
    description = "Create the marker file for service A (touch /tmp/svc_a.done)"

    config {
      timeout = "60s"
    }

    setup {
      script = "scripts/task/service_checks/setup_markers.sh"
    }

    check {
      script          = "scripts/task/service_checks/check_service_a.sh"
      failure_message = "Marker /tmp/svc_a.done not found. Create it with: touch /tmp/svc_a.done"

      config {
        timeout = "45s"
      }
    }

    solve {
      script = "scripts/task/service_checks/solve_service_a.sh"
    }

    cleanup {
      script = "scripts/task/service_checks/cleanup_markers.sh"
    }
  }

  condition "check_service_b" {
    description = "Create the marker file for service B (touch /tmp/svc_b.done)"

    check {
      script          = "scripts/task/service_checks/check_service_b.sh"
      failure_message = "Marker /tmp/svc_b.done not found. Create it with: touch /tmp/svc_b.done"
    }

    solve {
      script = "scripts/task/service_checks/solve_service_b.sh"
    }
  }

  condition "check_service_c" {
    description = "Create the marker file for service C (touch /tmp/svc_c.done)"

    check {
      script          = "scripts/task/service_checks/check_service_c.sh"
      failure_message = "Marker /tmp/svc_c.done not found. Create it with: touch /tmp/svc_c.done"
    }

    solve {
      script = "scripts/task/service_checks/solve_service_c.sh"
    }
  }
}
