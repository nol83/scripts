#!/bin/bash

less recentRepos | awk 'BEGIN { FS = " "}{print $4}' | awk ' !x[$0]++' > authors
