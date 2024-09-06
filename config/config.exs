# Import the Config module
import Config

config :spark,
  formatter: [
    "Ash.Resource": [section_order: [:json_api]],
    "Ash.Domain": [section_order: [:json_api]]
  ]

# Configure the Ash domain
config :ash_ai, ash_domains: [Twitter.Support]
