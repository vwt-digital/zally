package main

import (
	"github.com/urfave/cli"
	"github.com/zalando/zally/cli/zally/commands"
)

// CreateApp creates CLI application with defined commands
func CreateApp() *cli.App {
	app := cli.NewApp()
	app.Name = "Zally-CLI"
	app.Version = "1.1"
	app.Usage = "Zally Command Line Interface"

	app.Commands = []cli.Command{
		commands.SupportedRulesCommand,
		commands.LintCommand,
	}

	app.Flags = []cli.Flag{
		cli.StringFlag{
			Name:   "linter-service, l",
			Usage:  "Linter service `URL`",
			Value:  "http://localhost:8080",
			EnvVar: "ZALLY_URL",
		},
		cli.StringFlag{
			Name:   "token, t",
			Usage:  "OAuth2 Token `OAUTH2_TOKEN`",
			EnvVar: "TOKEN",
		},
		cli.StringFlag{
			Name:  "format",
			Usage: "Output format `[pretty|markdown|text]`",
			Value: "pretty",
		},
	}

	return app
}
