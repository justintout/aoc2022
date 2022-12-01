BEGIN{e=1} {cals[e] += $1} /$^/{e++} END{asort(cals, s, "@val_num_desc"); x = s[1] + s[2] + s[3]; print x}
