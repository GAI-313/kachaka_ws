#!/usr/bin/env python3

from rclpy.node import Node
import rclpy

from tf2_ros import Buffer

from erasers_kachaka_common import Kachaka
from erasers_kachaka_common.tts import TTS
from erasers_kachaka_common.kachaka import *
from erasers_kachaka_common.navigator import Nav2Navigation

import os


rclpy.init()
__node = Node('ierk_console')


__buffer = Buffer()


kachaka = Kachaka(__node, __buffer)


print('ierk interactive shell Ver. 2.0.0')
print('ierk interactive shell start')

print("""
       ____     ____                          _  __              _             _           
  ___ |  _ \   / __ \  ___   ___  _ __  ___  | |/ /  __ _   ___ | |__    __ _ | | __  __ _ 
 / _ \| |_) | / / _` |/ __| / _ \| '__|/ __| | ' /  / _` | / __|| '_ \  / _` || |/ / / _` |
|  __/|  _ < | | (_| |\__ \|  __/| |   \__ \ | . \ | (_| || (__ | | | || (_| ||   < | (_| |
 \___||_| \_\ \ \__,_||___/ \___||_|   |___/ |_|\_\ \__,_| \___||_| |_| \__,_||_|\_\ \__,_|
               \____/                                                                      

""")
