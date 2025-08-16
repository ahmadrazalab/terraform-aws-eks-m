# ALB Ingress for TraceMyPods

resource "kubernetes_ingress_v1" "ai_frontend_ingress" {
  metadata {
    name      = "tracemypods-ingress"
    namespace = "ai-assistant"
    annotations = {
      "alb.ingress.kubernetes.io/scheme"              = "internet-facing"
      "alb.ingress.kubernetes.io/target-type"         = "ip"
      "alb.ingress.kubernetes.io/listen-ports"        = "[{\"HTTP\": 80}, {\"HTTPS\": 443}]"
      "alb.ingress.kubernetes.io/certificate-arn"     = "arn:aws:acm:ap-south-1:x:certificate/x"
      "alb.ingress.kubernetes.io/ssl-policy"          = "ELBSecurityPolicy-2016-08"
      "alb.ingress.kubernetes.io/healthcheck-path"   = "/"
      # "alb.ingress.kubernetes.io/healthcheck-protocol"= "TCP"
      # "alb.ingress.kubernetes.io/healthcheck-port"    = "traffic-port"
      # "alb.ingress.kubernetes.io/actions.ssl-redirect" = jsonencode({
      #   Type = "redirect"
      #   RedirectConfig = {
      #     Protocol = "HTTPS"
      #     Port     = "443"
      #     StatusCode = "HTTP_301"
      #   }
      # })

    }
  }

  spec {
    ingress_class_name = "alb"

    rule {
      host = "assist.ahmadraza.in"

      http {
        # Frontend
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "tracemypods-frontend-service"
              port {
                number = 80
              }
            }
          }
        }

        # Ask API
        path {
          path      = "/api/ask"
          path_type = "Prefix"
          backend {
            service {
              name = "tracemypods-askapi-service"
              port {
                number = 3002
              }
            }
          }
        }

        # Admin API
        path {
          path      = "/api/redis-data"
          path_type = "Prefix"
          backend {
            service {
              name = "tracemypods-adminapi-service"
              port {
                number = 3004
              }
            }
          }
        }
        path {
          path      = "/api/db-data"
          path_type = "Prefix"
          backend {
            service {
              name = "tracemypods-adminapi-service"
              port {
                number = 3004
              }
            }
          }
        }
        path {
          path      = "/api/s3-data"
          path_type = "Prefix"
          backend {
            service {
              name = "tracemypods-adminapi-service"
              port {
                number = 3004
              }
            }
          }
        }
        path {
          path      = "/api/s3-page"
          path_type = "Prefix"
          backend {
            service {
              name = "tracemypods-adminapi-service"
              port {
                number = 3004
              }
            }
          }
        }
        path {
          path      = "/api/s3-analytics"
          path_type = "Prefix"
          backend {
            service {
              name = "tracemypods-adminapi-service"
              port {
                number = 3004
              }
            }
          }
        }
        path {
          path      = "/api/s3-presigned"
          path_type = "Prefix"
          backend {
            service {
              name = "tracemypods-adminapi-service"
              port {
                number = 3004
              }
            }
          }
        }
        path {
          path      = "/api/s3-folders"
          path_type = "Prefix"
          backend {
            service {
              name = "tracemypods-adminapi-service"
              port {
                number = 3004
              }
            }
          }
        }
        path {
          path      = "/api/s3-search"
          path_type = "Prefix"
          backend {
            service {
              name = "tracemypods-adminapi-service"
              port {
                number = 3004
              }
            }
          }
        }

        # Deliver API
        path {
          path      = "/deliver"
          path_type = "Prefix"
          backend {
            service {
              name = "tracemypods-deliverapi-service"
              port {
                number = 3000
              }
            }
          }
        }

        # Order API
        path {
          path      = "/order"
          path_type = "Prefix"
          backend {
            service {
              name = "tracemypods-orderapi-service"
              port {
                number = 3000
              }
            }
          }
        }

        # Payment API
        path {
          path      = "/send-otp"
          path_type = "Prefix"
          backend {
            service {
              name = "tracemypods-paymentapi-service"
              port {
                number = 3007
              }
            }
          }
        }
        path {
          path      = "/verify-otp"
          path_type = "Prefix"
          backend {
            service {
              name = "tracemypods-paymentapi-service"
              port {
                number = 3007
              }
            }
          }
        }
        path {
          path      = "/create-order"
          path_type = "Prefix"
          backend {
            service {
              name = "tracemypods-paymentapi-service"
              port {
                number = 3007
              }
            }
          }
        }
        path {
          path      = "/verify-payment"
          path_type = "Prefix"
          backend {
            service {
              name = "tracemypods-paymentapi-service"
              port {
                number = 3007
              }
            }
          }
        }

        # Token API
        path {
          path      = "/api/token"
          path_type = "Prefix"
          backend {
            service {
              name = "tracemypods-tokenapi-service"
              port {
                number = 3001
              }
            }
          }
        }
        path {
          path      = "/api/validate-premium-token"
          path_type = "Prefix"
          backend {
            service {
              name = "tracemypods-tokenapi-service"
              port {
                number = 3001
              }
            }
          }
        }

        # Otel API
        path {
          path      = "/api/services"
          path_type = "Prefix"
          backend {
            service {
              name = "otelapi-service"
              port {
                number = 3000
              }
            }
          }
        }
        path {
          path      = "/api/heatmap"
          path_type = "Prefix"
          backend {
            service {
              name = "otelapi-service"
              port {
                number = 3000
              }
            }
          }
        }
        path {
          path      = "/api/traces"
          path_type = "Prefix"
          backend {
            service {
              name = "otelapi-service"
              port {
                number = 3000
              }
            }
          }
        }
        path {
          path      = "/api/chat"
          path_type = "Prefix"
          backend {
            service {
              name = "otelapi-service"
              port {
                number = 3000
              }
            }
          }
        }
        path {
          path      = "/api/optimize"
          path_type = "Prefix"
          backend {
            service {
              name = "otelapi-service"
              port {
                number = 3000
              }
            }
          }
        }

        # Otel Viz
        path {
          path      = "/otel"
          path_type = "Prefix"
          backend {
            service {
              name = "oteldash-service"
              port {
                number = 80
              }
            }
          }
        }

        # Frontend fallback
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "tracemypods-frontend-service"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}

data "kubernetes_ingress_v1" "ai_frontend_ingress_status" {
  metadata {
    name      = kubernetes_ingress_v1.ai_frontend_ingress.metadata[0].name
    namespace = kubernetes_ingress_v1.ai_frontend_ingress.metadata[0].namespace
  }
}

output "alb_dns_name" {
  value = try(data.kubernetes_ingress_v1.ai_frontend_ingress_status.status[0].load_balancer[0].ingress[0].hostname, "")
}


