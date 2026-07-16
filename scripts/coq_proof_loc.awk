# Heuristic proof-vs-spec line splitter for Coq/Rocq .v files.
# Counts non-blank, non-comment physical lines INSIDE Proof ... (Qed|Defined|
# Admitted|Abort) blocks as "proof", everything else as "spec/definition".
#
# Limitations (all approximations):
#  - Term-mode proofs (Definition foo := ... with no Proof block) count as spec.
#  - Proof. ... Qed. all on ONE line: the whole line counts as proof.
#  - Comments are stripped only for (* ... *) that open and close on one line
#    or span lines; nested comments handled by depth counter.
#  - Strings are not specially parsed; "Qed" inside a string is unlikely in .v.
BEGIN { inproof=0; cdepth=0; proof=0; spec=0 }
FNR==1 { inproof=0; cdepth=0 }   # reset per-file so comment/proof state never leaks across files
{
  line=$0
  # strip (* ... *) comments with nesting, tracking across lines
  out=""; i=1; n=length(line)
  while (i<=n) {
    two=substr(line,i,2)
    if (cdepth>0) {
      if (two=="*)") { cdepth--; i+=2; continue }
      if (two=="(*") { cdepth++; i+=2; continue }
      i++; continue
    } else {
      if (two=="(*") { cdepth++; i+=2; continue }
      out=out substr(line,i,1); i++
    }
  }
  gsub(/^[ \t]+|[ \t]+$/,"",out)
  if (out=="") next            # blank or comment-only line
  if (inproof) {
    proof++
    if (out ~ /(^|[ \t.;])(Qed|Defined|Admitted|Abort)([ \t.;]|$)/ || out ~ /(Qed|Defined|Admitted|Abort)\.$/)
      inproof=0
  } else {
    # A line that opens a proof block
    if (out ~ /(^|[ \t.;])Proof([ \t.;]|$)/ || out ~ /Proof\./) {
      proof++
      # single-line Proof. ... Qed.
      if (out ~ /(Qed|Defined|Admitted|Abort)\.?[ \t]*$/) inproof=0
      else inproof=1
    } else {
      spec++
    }
  }
}
END { printf "%d %d %d\n", proof, spec, proof+spec }
