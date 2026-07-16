# Heuristic proof-vs-spec splitter for HOL4 .sml proof scripts (modern syntax).
# Lines inside  Proof ... QED  blocks count as proof; Definition/Datatype/
# Theorem-statement/other lines count as spec.  Comments are SML (* ... *),
# nesting-aware; state is reset per file.
# Limitation: legacy proofs written as  val t = store_thm(...)/prove(...)  are
# NOT delimited by Proof/QED and count as spec -> a slight proof UNDER-count
# (~3% of theorems in the CakeML compiler use the legacy form).
BEGIN { inproof=0; cdepth=0; proof=0; spec=0 }
FNR==1 { inproof=0; cdepth=0 }
{
  line=$0; out=""; i=1; n=length(line)
  while (i<=n) {
    two=substr(line,i,2)
    if (cdepth>0) { if (two=="*)"){cdepth--;i+=2;continue} if(two=="(*"){cdepth++;i+=2;continue} i++; continue }
    else { if (two=="(*"){cdepth++;i+=2;continue} out=out substr(line,i,1); i++ }
  }
  gsub(/^[ \t]+|[ \t]+$/,"",out)
  if (out=="") next
  if (inproof) { proof++; if (out ~ /^QED([ \t]|$)/ || out=="QED") inproof=0 }
  else {
    if (out=="Proof" || out ~ /^Proof([ \t]|$)/) { proof++; inproof=1 }
    else spec++
  }
}
END { printf "%d %d %d\n", proof, spec, proof+spec }
