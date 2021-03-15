#!/bin/bash
plantuml "c4/*.pum" -x "c4/*style.pum" -o "./out"
plantuml "sequence/*.pum" -x "sequence/*style.pum" -o "./out"
