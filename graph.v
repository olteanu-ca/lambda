From Hammer Require Hammer.
Require MSets Orders.

Module GraphLink (L:Orders.UsualOrderedType) <: Orders.UsualOrderedType.
 Import Orders.
 Definition t := (BinNat.N.t * BinNat.N.t * L.t)%type.
 Definition eq (a b : t) := a = b.
 Definition eq_equiv : Equivalence eq.
 Proof.
   constructor.
   - constructor.
   - unfold Symmetric. intuition.
   - unfold Transitive. Reconstr.scrush.
 Defined.
 Definition lt (a b : t) : Prop :=
   match a,b with
   | (a_source, a_dest, a_label),
     (b_source, b_dest, b_label)
     => BinNat.N.lt a_source b_source \/
        (a_source = b_source /\
         ((BinNat.N.lt a_dest b_dest) \/
         (a_dest = b_dest /\ L.lt a_label b_label))) end.
 Lemma lt_strorder : StrictOrder lt.
 Proof.
   pose (BinNat.N.lt_strorder).
   pose (L.lt_strorder).
   constructor.
   - unfold Irreflexive. unfold Reflexive. unfold complement. unfold lt.
     Reconstr.scrush.
   - unfold Transitive. unfold lt. Reconstr.scrush.
 Defined.
 Lemma lt_compat : Proper (eq ==> eq ==> iff) lt.
 Proof.
   unfold Proper. unfold "==>". unfold eq. unfold lt.
   pose (BinNat.N.lt_compat). pose (L.lt_compat).
   Reconstr.scrush.
 Defined.
 Definition compare (a b : t) : comparison :=
   match a, b with
   | (a_source, a_dest, a_label),
     (b_source, b_dest, b_label)
     => match (BinNat.N.compare a_source b_source) with
        | Eq => match (BinNat.N.compare a_dest b_dest) with
                | Eq => L.compare a_label b_label
                | dest_comp => dest_comp end
        | source_comp => source_comp end end.
 Lemma compare_spec (a b : t) : CompareSpec (eq a b) (lt a b) (lt b a) (compare a b).
 Proof.
   unfold eq. unfold lt.
   Module N_Order_Facts := OrdersFacts.OrderedTypeFacts (BinNat.N).
   Module L_Order_Facts := OrdersFacts.OrderedTypeFacts (L).
   refine (match a,b with
           | (a_source, a_dest, a_label),
             (b_source, b_dest, b_label) => _ end).
   pose (n_eq := N_Order_Facts.compare_eq).
   pose (l_eq := L_Order_Facts.compare_eq).
   destruct (BinNat.N.compare a_source b_source) eqn:source_cmp.
   - destruct (BinNat.N.compare a_dest b_dest) eqn:dest_cmp.
     + destruct (L.compare a_label b_label) eqn:label_cmp.
       * pose (l_rewr := l_eq _ _ label_cmp).
         pose (source_rewr := n_eq _ _ source_cmp).
         pose (dest_rewr := n_eq _ _ dest_cmp).
         rewrite l_rewr; rewrite source_rewr; rewrite dest_rewr.
         Reconstr.scrush.
       * 
   
 Definition eq_dec (a b : t) : {eq a b} + {eq a b -> False}.
 Proof.
   unfold eq.
   refine (match a,b with
           | (a_source, a_dest, a_label),
             (b_source, b_dest, b_label)
               => _ end).
   destruct (BinNat.N.eq_dec a_source b_source).
   - destruct (BinNat.N.eq_dec a_dest b_dest).
     + destruct (L.eq_dec a_label b_label); Reconstr.sauto.
     + Reconstr.sauto.
   - Reconstr.sauto.
 Defined.
End GraphLink.

(*Module Graph (L:Orders.UsualOrderedType).
 Print Orders.UsualOrderedType.*)