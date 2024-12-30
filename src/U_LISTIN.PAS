Unit U_Listing;              { mise … jour le 21/07/1991. }
{
Logiciel: ED_COBOL.

Auteur: Pr‚martin Patrick.
Date: 10/03/1991.
      20/07/1991.
      21/07/1991.

But: Op‚rations ‚l‚mentaires sur le listing.
}
{ $define demo_vers}
Interface

Uses
    Crt,
    U_Utilitaire,
    U_Variables;

Var
   Code_Source : T_Code_Source;

Procedure Initialisation_Listing;
          { Initialisation du listing. }
Procedure Supprime_Ligne;
          { Supprime la ligne courante. }
Procedure Insere_Ligne;
          { InsŠre une ligne … la position courante. }
Procedure Traite_Ligne;
          { EnlŠve les espaces … droite de la ligne. }
procedure decal_lig (lig_1, lig_2 : integer);
          { D‚cale les lignes dans le sens lig_2 vers lig_1 en remplacant le
          contenu de lig_2 par le contenu de lig_1. }

Implementation
Procedure Ins_Line;
Begin
     Gotoxy (1, Y);
     Textcolor (c_col_txt_listing);
     Textbackground (c_col_bck_listing);
     Insline;
End; { ins_line }

Procedure Del_Line;
Begin
     Gotoxy (1, 1);
     Textcolor (c_col_txt_listing);
     Textbackground (c_col_bck_listing);
     Delline;
End; { del_line }

Procedure Initialisation_Listing;
Var
   I : Integer;
Begin
     With Code_Source Do
          Begin
               For I := 1 To Nb_Max_Ligne Do
                   Lignes [I] := '';
               {endfor}
               Nb_Lig := 1;
          End;
     {endwith}
     Lig := 1;
     Num_Ligne_1 := 1;
End; { initialisation_listing }

procedure decal_lig (lig_1, lig_2 : integer);
var
   old_lig : t_ligne;
   i : integer;
begin
     old_lig := code_source.lignes [lig_1];
     if (lig_1 < lig_2)
     then
         for i := lig_1 to pred (lig_2) do
             code_source.lignes [i] := code_source.lignes [succ (i)]
         {endfor}
     else
         for i := lig_1 downto succ (lig_2) do
             code_source.lignes [i] := code_source.lignes [pred (i)];
         {endfor}
     {endif}
     code_source.lignes [lig_2] := old_lig;
end; { decal_lig }

Procedure Supprime_Ligne;
Var
   I : Integer;
Begin
     if (lig <= ln_fin_bloc)
     then
         begin
              dec (ln_fin_bloc);
              if (lig < ln_deb_bloc)
              then
                  dec (ln_deb_bloc);
              {endif}
         end;
     {endif}
     With Code_Source Do
          Begin
               decal_lig (lig, nb_lig);
               Dec (Nb_Lig);
          End;
     {endwith}
End; { supprime_ligne }

Procedure Insere_Ligne;
Var
   I : Integer;
Begin
     If (Code_Source.Nb_Lig >= Nb_Max_Ligne)
     Then
         Message_Alerte ('Buffer plein, changez de programme.', True)
     Else
         Begin
              If ((X > 1) Or (Length (Code_Source.Lignes [Lig]) = 0))
              Then
                  Begin
                       Inc (Lig);
                       If (Y < 19)
                       Then
                           Inc (Y)
                       Else
                           Begin
                                Inc (Num_Ligne_1);
                                Del_Line;
                           End;
                       {endif}
                  End;
              {endif}
              X := 1;
              if (lig < ln_deb_bloc)
              then
                  begin
                       inc (ln_deb_bloc);
                       inc (ln_fin_bloc);
                  end
              else
                  if (lig <= ln_fin_bloc)
                  then
                      inc (ln_fin_bloc);
                  {endif}
              {endif}
              With Code_Source Do
                   Begin
                        Inc (Nb_Lig);
                        decal_lig (nb_lig, lig);
                        Lignes [Lig] := '';
                   End;
              {endwith}
              Ins_Line;
         End;
     {endif}
End; { insere_ligne }

Procedure Traite_Ligne;
Var
   I : Integer;
Begin
     With Code_Source Do
          Begin
               I := Length (Lignes [Lig]);
               While Not ((I < 1) Or (Lignes [Lig] [I] <> ' ')) Do
                     Dec (I);
               {endwhile}
               Lignes [Lig] := Copy (Lignes [Lig], 1, I);
          End;
     {endwith}
End; { traite_ligne }

End. { Fin de l'unit‚ 'U_Listing'. }
