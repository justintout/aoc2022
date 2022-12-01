BEGIN{e=1} {cals[e] = cals[e] + $1} /^$/{e++} END{asort(cals, s, "@val_num_desc"); print s[1]}
