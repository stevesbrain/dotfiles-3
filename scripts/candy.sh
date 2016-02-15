#!/bin/sh

f0='[30m'; f1='[31m'; f2='[32m'; f3='[33m'; f4='[34m'; f5='[35m'; f6='[36m'; f7='[37m'
b0='[40m'; b1='[41m'; b2='[42m'; b4='[44m'; b4='[44m'; b5='[45m'; b6='[46m'; b7='[47m'

B='[1m'
R='[0m'
I='[7m'

if [ "$1" = "-v" ] || [ "$1" = "--vertical" ]
then

cat << EOF

 $f0████████
 $f0██▒▒▒▒$f0██
 $f0██▒▒▒▒$f0██
 $f0████████

 $f1████████
 $f1██▒▒▒▒$f1██
 $f1██▒▒▒▒$f1██
 $f1████████

 $f2████████
 $f2██▒▒▒▒$f2██
 $f2██▒▒▒▒$f2██
 $f2████████

 $f3████████
 $f3██▒▒▒▒$f3██
 $f3██▒▒▒▒$f3██
 $f3████████

 $f4████████
 $f4██▒▒▒▒$f4██
 $f4██▒▒▒▒$f4██
 $f4████████

 $f5████████
 $f5██▒▒▒▒$f5██
 $f5██▒▒▒▒$f5██
 $f5████████

 $f6████████
 $f6██▒▒▒▒$f6██
 $f6██▒▒▒▒$f6██
 $f6████████

 $f7████████
 $f7██▒▒▒▒$f7██
 $f7██▒▒▒▒$f7██
 $f7████████$R

EOF

else

cat << EOF

 $f0████████ $f1████████ $f2████████ $f3████████ $f4████████ $f5████████ $f6████████ $f7████████
 $f0██▒▒▒▒$f0██ $f1██▒▒▒▒$R$f1██ $f2██▒▒▒▒$R$f2██ $f3██▒▒▒▒$R$f3██ $f4██▒▒▒▒$R$f4██ $f5██▒▒▒▒$R$f5██ $f6██▒▒▒▒$R$f6██ $f7██▒▒▒▒$R$f7██
 $f0██▒▒▒▒$f0██ $f1██▒▒▒▒$R$f1██ $f2██▒▒▒▒$R$f2██ $f3██▒▒▒▒$R$f3██ $f4██▒▒▒▒$R$f4██ $f5██▒▒▒▒$R$f5██ $f6██▒▒▒▒$R$f6██ $f7██▒▒▒▒$R$f7██
 $f0████████ $f1████████ $f2████████ $f3████████ $f4████████ $f5████████ $f6████████ $f7████████$R

EOF

fi
