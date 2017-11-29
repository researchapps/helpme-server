// +build go1.6

// Copyright 2014 The Gogs Authors. All rights reserved.
// Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

// Collaborative knowledge and support for scientific computing

package main

import (
	"os"

	"github.com/urfave/cli"

	"github.com/gogits/gogs/cmd"
	"github.com/gogits/gogs/pkg/setting"
)

const APP_VER = "0.11.34.1122"

func init() {
	setting.AppVer = APP_VER
}

func main() {
	app := cli.NewApp()
	app.Name = "HelpMe"
	app.Usage = "Collaborative knowledge and support for scientific computing"
	app.Version = APP_VER
	app.Commands = []cli.Command{
		cmd.Web,
		cmd.Serv,
		cmd.Hook,
		cmd.Cert,
		cmd.Admin,
		cmd.Import,
		cmd.Backup,
		cmd.Restore,
	}
	app.Flags = append(app.Flags, []cli.Flag{}...)
	app.Run(os.Args)
}
