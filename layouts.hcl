# ==============================================================================
# layouts.hcl — UI layouts.
# Source pages: /reference/content/layout/ and /getting-started/code/content-tasks/
# ==============================================================================

# Source: /getting-started/code/content-tasks/ — "Create the Layout Configuration"
resource "layout" "two_column" {
  column {
    width = "50"

    instructions {}
  }

  column {
    width = "50"

    tab "terminal" {
      title  = "Terminal"
      target = resource.terminal.shell
    }

    tab "service" {
      title  = "Service"
      target = resource.service.webserver
    }
  }
}

# Source: /reference/content/layout/ — "Three Column Layout" (tab targets mapped
# to this lab's resources; includes tab options from "Full Syntax").
resource "layout" "three_column" {
  column {
    width = "25"

    instructions {}
  }

  column {
    width = "50"

    tab "terminal" {
      target = resource.terminal.k8s_terminal
      active = true
    }

    tab "terminal2" {
      target = resource.terminal.workstation
    }
  }

  column {
    width = "25"

    tab "notes" {
      target = resource.note.command_cheatsheet
    }

    # Tab options from /reference/content/layout/ — "Full Syntax"
    tab "docs" {
      title     = "K8s Docs"
      target    = resource.external_website.kubernetes_docs
      active    = false
      visible   = true
      closeable = false
      movable   = false
    }
  }
}

# Source: /reference/content/layout/ — "Complex Layout with Rows"
resource "layout" "complex" {
  column {
    width = "40"

    instructions {}
  }

  column {
    width = "60"

    row {
      height = "70"

      tab "terminal" {
        target = resource.terminal.workstation
        active = true
      }

      tab "editor" {
        target = resource.editor.config_editor
      }
    }

    row {
      height = "30"

      tab "service" {
        target = resource.service.webserver
      }
    }
  }
}

# Source: /reference/content/layout/ — "Nested Layout"
resource "layout" "nested" {
  column {
    width = "30"

    row {
      height = "50"
      instructions {}
    }

    row {
      height = "50"
      tab "notes" {
        target = resource.note.api_reference
      }
    }
  }

  column {
    width = "70"

    row {
      height = "60"

      column {
        width = "60"
        tab "terminal" {
          target = resource.terminal.shell
        }
      }

      column {
        width = "40"
        tab "editor" {
          target = resource.editor.config_editor
        }
      }
    }

    row {
      height = "40"
      tab "service" {
        target = resource.service.webserver
      }
    }
  }
}

# Source: /reference/sandbox/ui/cloud-credentials/ — "Integration with Layout"
# (cloud credentials tab; the tab is only useful when variable.enable_cloud
# is true) plus a virtual browser tab from /reference/sandbox/ui/virtualbrowser/.
resource "layout" "cloud" {
  column {
    width = "40"

    instructions {}
  }

  column {
    width = "60"

    tab "shell" {
      title  = "Shell"
      target = resource.terminal.workstation
    }

    tab "browser" {
      title  = "Browser"
      target = resource.virtual_browser.docs
    }
  }
}
