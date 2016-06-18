#!/usr/bin/python

import argparse
import configparser
import datetime
import os
import re
import socket

# ==============================================================================
def message(text):
		print('┌──────────────────────────────────────────────────────────────────────────────────┐')
		print('│ %-80s │' % text)
		print('└──────────────────────────────────────────────────────────────────────────────────┘')

# ==============================================================================

class Archive:
	def __init__(self,cfg):
		config = configparser.RawConfigParser()
		config.read(cfg)
		self.cfg     = cfg
		self.name    = config['MAIN']['name']
		self.archive = config['MAIN']['archive']
		self.prefix  = re.sub('\$\(hostname\)', socket.gethostname(), config['MAIN']['prefix'])
		self.files   = config['FILES'  ] if config.has_section('FILES'  ) else []
		self.exclude = config['EXCLUDE'] if config.has_section('EXCLUDE') else []
		self.local   = config['LOCAL'  ] if config.has_section('LOCAL'  ) else []
		self.remote  = config['REMOTE' ] if config.has_section('REMOTE' ) else []
		self.prune   = config['PRUNE'  ] if config.has_section('PRUNE'  ) else None

	def list(self):
		message('%s - %s' % (self.name, 'List checkpoint'))
		# List
		os.system('attic list %s' % self.archive)

	def commit(self):
		message('%s - %s' % (self.name, 'Creating checkpoint'))
		# Create
		cmd = 'attic create -s %s::%s-%s' % (self.archive, self.prefix, datetime.datetime.now().strftime("%Y%m%d_%H%M"))
		for dest in self.files:   cmd += ' %s'           % self.files[dest]
		for dest in self.exclude: cmd += ' --exclude %s' % self.exclude[dest]
		os.system(cmd)
		# Prune
		if (self.prune):
			os.system('attic prune %s %s' % (self.archive, self.prune['settings']))

	def push(self):
		message('%s - %s' % (self.name, 'Pushing to remote'))
		# Push
		for dest in self.local:
			if os.path.exists(self.local[dest]):
				os.system('rsync -avz --delete %s %s' % (self.archive, self.local[dest]))
			else:
				print('[WARNING] Could not push to `%s`, path doesn\'t exist' % self.local[dest])
		for dest in self.remote:
			os.system('rsync -avz --delete %s %s' % (self.archive, self.remote[dest]))

# ==============================================================================

import glob
class Archives:
	def __init__(self, cfgdir):
		self.map = dict();
		for cfg in glob.glob(cfgdir+"*.cfg"):
			archive = Archive(cfg)
			self.map[archive.name] = archive

	def list(self, names):
		for name in names:
			self.map[name].list()

	def commit(self, names):
		for name in names:
			self.map[name].commit()

	def push(self, names):
		for name in names:
			self.map[name].push()

	def show(self):
		print('┌──────────────────────────────────────────────────────────────────────────────────┐')
		print('│ %-80s │' % 'Archives List')
		print('├──────────────────────────────────────────────────────────────────────────────────┤')
		for name in self.map:
			print('│ [%-10s] %-67s │' % (name, self.map[name].cfg))
		print('└──────────────────────────────────────────────────────────────────────────────────┘')

	def all(self):
		return [key for key in self.map]

# ==============================================================================

if __name__ == '__main__':

	# Parse argument
	parser = argparse.ArgumentParser()
	parser.add_argument('list', nargs='*')
	group = parser.add_mutually_exclusive_group(required=True)
	group.add_argument ('-l',    action='store_true')
	group.add_argument ('-c',    action='store_true')
	group.add_argument ('-p',    action='store_true')
	group.add_argument ('-b',    action='store_true')
	parser.add_argument('--all', action='store_true')
	args = parser.parse_args()

	# Load configs
	configs = Archives("/home/amxx/.attic/configs/")

	# Fill archive list
	if args.all:
		args.list = configs.all()
	elif len(args.list) == 0:
		configs.show()
		value = input('Select archive: ')
		if value in ['', '*']:
			args.list = configs.all()
		else:
			args.list = re.split(' ', value)

	# Sanity check
	for name in set(args.list) - set(configs.all()):
		print('[WARNING] unknwon archive: %s' % name)
	args.list = set(args.list) & set(configs.all())

	# Run
	if args.l:           configs.list  (args.list)
	if args.c or args.b: configs.commit(args.list)
	if args.p or args.b: configs.push  (args.list)
