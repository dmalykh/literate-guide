# ==============================================================================
# main.hcl — the lab resource.
# Every block in this repository is a documented example from
# https://docs.labs.instruqt.com — each carries a "Source:" comment naming the
# docs page (and example heading) it was taken from, so a failure maps straight
# back to the docs page that needs fixing.
# ==============================================================================

# Source: /reference/content/lab/ — "Full Syntax" + "Lab with Custom Settings",
# combined with the content structure from /getting-started/code/content-tasks/.
resource "lab" "main" {
  title       = "Docs Example Gallery"
  description = "A lab assembled exclusively from the examples in the Instruqt docs. Every resource, task, quiz, layout and function usage in this repository is a documented example; its Source comment names the page it came from. Use it to verify that all documented examples are workable."
  icon        = "assets/icon.png"

  # Source: /reference/content/lab/ — settings block from "Full Syntax".
  # NOTE (docs finding): the Full Syntax example on /reference/content/lab/ uses
  # theme = "modern_dark", which fails validation — allowed values are
  # "modern-dark" or "original".
  settings {
    theme = "modern-dark"

    timelimit {
      duration   = "2h"
      extend     = "30m"
      show_timer = true
    }

    idle {
      enabled      = true
      timeout      = "15m"
      show_warning = true
    }

    controls {
      show_stop = true
    }
  }

  # Source: /reference/content/lab/ — "Layout Inheritance": lab default layout,
  # chapter-level override, page-level override.
  layout = resource.layout.two_column

  content {
    title = "Course Material"

    chapter "getting_started" {
      title = "Getting Started with Web Servers"

      page "welcome" {
        reference = resource.page.welcome
      }

      page "customize_homepage" {
        reference = resource.page.customize_homepage
      }
    }

    chapter "sandbox_resources" {
      title = "Sandbox Resources"

      page "containers" {
        # Page-level layout override.
        # Source: /reference/content/lab/ — "Layout Inheritance"
        layout    = resource.layout.complex
        reference = resource.page.containers
      }

      page "vm" {
        reference = resource.page.vm
      }
    }

    chapter "orchestration" {
      title = "Orchestration"
      # Chapter-level layout override.
      # Source: /reference/content/lab/ — "Layout Inheritance"
      layout = resource.layout.three_column

      page "kubernetes" {
        reference = resource.page.kubernetes
      }

      page "nomad" {
        reference = resource.page.nomad
      }
    }

    chapter "activities" {
      title = "Tasks & Quizzes"

      page "tasks_deep_dive" {
        reference = resource.page.tasks_deep_dive
      }

      page "quiz_page" {
        title     = "Knowledge Assessment"
        reference = resource.page.quiz_page
      }
    }

    chapter "dynamic" {
      title = "Dynamic Values & Cloud"

      page "dynamic_values" {
        reference = resource.page.dynamic_values
      }

      page "cloud" {
        layout    = resource.layout.cloud
        reference = resource.page.cloud
      }
    }

    chapter "finish" {
      title = "Wrap Up"

      page "finish" {
        layout    = resource.layout.nested
        reference = resource.page.finish
      }
    }
  }
}
