// +build integration

package config

import (
	"io/ioutil"
	"os"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestConfigSetLogLevel(t *testing.T) {
	f, err := ioutil.TempDir("/tmp", "newrelic")
	assert.NoError(t, err)
	defer os.RemoveAll(f)

	// Initialize the new configuration directory
	c, err := LoadConfig(f)
	assert.NoError(t, err)
	assert.Equal(t, c.configDir, f)

	// Set the valid log levels
	for _, l := range []string{
		"ERROR",
		"WARN",
		"INFO",
		"DEBUG",
		"TRACE",
	} {
		err = c.Set("logLevel", l)
		assert.NoError(t, err)
		assert.Equal(t, l, c.LogLevel)
	}

	err = c.Set("logLevel", "INVALID_VALUE")
	assert.Error(t, err)
}

func TestConfigSetSendUsageData(t *testing.T) {
	f, err := ioutil.TempDir("/tmp", "newrelic")
	assert.NoError(t, err)
	defer os.RemoveAll(f)

	// Initialize the new configuration directory
	c, err := LoadConfig(f)
	assert.NoError(t, err)
	assert.Equal(t, c.configDir, f)

	// Set the valid log levels
	for _, l := range []string{
		"NOT_ASKED",
		"DISALLOW",
		"ALLOW",
	} {
		err = c.Set("sendUsageData", l)
		assert.NoError(t, err)
		assert.Equal(t, l, c.SendUsageData)
	}

	err = c.Set("sendUsageData", "INVALID_VALUE")
	assert.Error(t, err)
}

func TestConfigSetPluginDir(t *testing.T) {
	f, err := ioutil.TempDir("/tmp", "newrelic")
	assert.NoError(t, err)
	defer os.RemoveAll(f)

	// Initialize the new configuration directory
	c, err := LoadConfig(f)
	assert.NoError(t, err)
	assert.Equal(t, c.configDir, f)

	err = c.Set("pluginDir", "test")
	assert.NoError(t, err)
	assert.Equal(t, "test", c.PluginDir)
}
