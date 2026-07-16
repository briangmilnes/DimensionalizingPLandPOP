# ROUGH proof-vs-spec splitter for Isabelle .thy files. Isabelle proofs are not
# delimited by a single open/close keyword, so this classifies each non-blank,
# non-comment line by its LEADING keyword:
#   proof  = apply/by/done/qed/proof/next/show/have/hence/thus/from/with/obtain/
#            fix/assume/presume/then/moreover/ultimately/also/finally/using/
#            unfolding/supply/subgoal/defer/prefer/back/sorry/oops/note/case/let
#   spec   = everything else (theory/imports/definition/fun/datatype/record/
#            inductive/abbreviation/locale/class + the lemma/theorem STATEMENT
#            lines and any wrapped continuation lines).
# Consequences (state these): lemma/theorem statement lines and wrapped proof
# continuation lines count as SPEC, so proof is an UNDER-count / lower bound;
# text \<open>...\<close> documentation cartouches are counted as code by tokei
# and land in spec.  Only (* ... *) comments are stripped (nesting-aware).
BEGIN { cdepth=0; proof=0; spec=0 }
FNR==1 { cdepth=0 }
{
  line=$0; out=""; i=1; n=length(line)
  while (i<=n) {
    two=substr(line,i,2)
    if (cdepth>0) { if (two=="*)"){cdepth--;i+=2;continue} if(two=="(*"){cdepth++;i+=2;continue} i++; continue }
    else { if (two=="(*"){cdepth++;i+=2;continue} out=out substr(line,i,1); i++ }
  }
  gsub(/^[ \t]+/,"",out); gsub(/[ \t]+$/,"",out)
  if (out=="") next
  if (out ~ /^(apply|by|done|qed|proof|next|show|have|hence|thus|from|with|obtain|fix|assume|presume|then|moreover|ultimately|also|finally|using|unfolding|supply|subgoal|defer|prefer|back|sorry|oops|note|case|let)([ \t(.:]|$)/)
    proof++
  else spec++
}
END { printf "%d %d %d\n", proof, spec, proof+spec }
