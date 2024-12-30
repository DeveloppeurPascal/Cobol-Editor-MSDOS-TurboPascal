Unit U_Deplacement;          { Mise … jour le 20/07/1991. }
{
Logiciel: ED_COBOL.

Auteur: Pr‚martin Patrick.
Date: 09/03/1991.
      10/03/1991.
      18/07/1991.
      20/07/1991.

But: Gestion des d‚placements du curseur dans l'‚cran.
}
{ $define demo_vers}
Interface

Uses
    U_Curseur,
    U_Code_Clavier,
    U_Ecran,
    U_Listing,
    U_Variables;

Procedure Init_Coordonnees;
          { Initialise les variables de d‚placement du curseur. }
Procedure Set_Curseur;
          { Positionne le curseur en position courante. }
Procedure Suppression_Ligne;
          { Effacement de la ligne courante. }
Procedure Traitement_Backspace;
          { Effacement du caractŠre pr‚c‚dent le curseur. }
Procedure Traitement_Delete;
          { Effacement du caractŠre sous le curseur. }
Procedure Traitement_Return;
          { Gestion de l'appuit sur Return ou Enter. }
Procedure Traitement_Tabulation;
          { D‚placement du curseur de plusieurs tabulations. }
Procedure Traitement_Insertion_Caractere (Carac : Char);
          { Ajout d'un caractŠre dans la ligne courante. }

{ D‚placements du curseur dans l'‚cran et sur plusieurs ‚crans. }
Procedure Traitement_Bas;
Procedure Traitement_Haut;
Procedure Traitement_Gauche;
Procedure Traitement_Droite;
Procedure Traitement_Home;
Procedure Traitement_End;
Procedure Traitement_Page_Up;
Procedure Traitement_Page_Dn;
procedure traitement_ctrl_gauche;
procedure traitement_ctrl_droite;
procedure traitement_ctrl_page_up;
procedure traitement_ctrl_page_dn;

Implementation
function max (a, b : integer) : integer;
begin
     if a > b
     then
         max := a
     else
         max := b;
     {endif}
end; { max }

function min (a, b : integer) : integer;
begin
     if a < b
     then
         min := a
     else
         min := b;
     {endif}
end; { min }

Procedure Init_Coordonnees;
Begin { init_coordonnees }
  X := 1;
  Y := 1
End; { init_coordonnees }

Procedure Set_Curseur;
Begin { set_curseur }
  Met_Ligne_Titre (X, Y);
  Curseur_Locate (X + 6, Y + 5) { Localisation absolue du curseur, sans prise
                                  en compte de la fenŠtre cr‚e par CRT.       }
End; { set_curseur }

Procedure Suppression_Ligne;
Begin { suppression_ligne }
  If (Lig < Code_Source.Nb_Lig)
  Then
    Begin
      Supprime_Ligne;
      Affichage_Listing (Num_Ligne_1, Lig)
    End
  {endif}
End; { suppression_ligne }

Procedure Traitement_Backspace;
Begin { traitement_backspace }
  If (X > 1)
  Then
{ suppression d'un caractŠre }
    Begin
      Traitement_Gauche;
      Traitement_Delete
    End
  Else
{ suppression d'une ligne }
    If ((Length (Code_Source.Lignes [Lig]) < 1) And (Lig > 1))
    Then
      Begin
        Supprime_Ligne;
        Dec (Lig);
        X := Succ (Length (Code_Source.Lignes[Lig]));
        If (Y > 1)
        Then
          Dec (Y)
        Else
          Dec (Num_Ligne_1)
        {endif};
        Affichage_Listing (Num_Ligne_1, Lig)
      End
    Else
      If ((Length (Code_Source.Lignes [Pred (Lig)]) < 1) And (Lig > 1))
      Then
        Begin
          Dec (Lig);
          Supprime_Ligne;
          If (Y > 1)
          Then
            Dec (Y)
          Else
            Dec (Num_Ligne_1)
          {endif};
          Affichage_Listing (Num_Ligne_1, Lig)
        End
      {endif}
    {endif}
  {endif}
End; { traitement_backspace }

Procedure Traitement_Bas;
Begin { traitement_bas }
  Traite_Ligne;
  If (Lig < Code_Source.Nb_Lig)
  Then
    Begin
      If (Y < 19)
      Then
        Begin
          Inc (Lig);
          Inc (Y)
        End
      Else
        Begin
          Inc (Num_Ligne_1);
          Inc (Lig);
          Del_Line;
          Y := 19
        End
      {endif}
    End
  {endif};
  met_Ligne (Lig, Y);
  If (X > Succ (Length (Code_Source.Lignes [Lig])))
  Then
    X := Succ (Length (Code_Source.Lignes [Lig]))
  {endif}
End; { traitement_bas }

Procedure Traitement_Delete;
Begin { traitement_delete }
  If (X < Succ (Length (Code_Source.Lignes [Lig])))
  Then
{ suppression d'un caractŠre }
    Begin
      Delete (Code_Source.Lignes [Lig], X, 1);
      met_ligne (Lig, Y)
    End
  Else
    If ((Length (Code_Source.Lignes [Succ (Lig)]) < 1) And (Lig < Code_Source.Nb_Lig))
    Then
      Begin
        Inc (Lig);
        Supprime_Ligne;
        Dec (Lig);
        Affichage_Listing (Num_Ligne_1, Lig)
      End
    Else
      If ((Length (Code_Source.Lignes [Lig]) < 1) And (Lig < Code_Source.Nb_Lig))
      Then
        Begin
          Supprime_Ligne;
          Affichage_Listing (Num_Ligne_1, Lig)
        End
      {endif}
    {endif}
  {endif}
End; { traitement_delete }

Procedure Traitement_Droite;
Begin { traitement_droite }
  If (X < Succ (Length (Code_Source.Lignes [Lig])))
  Then
    Inc (X)
  Else
      begin
           traitement_bas;
           traitement_home;
      end;
  {endif}
  met_ligne (Lig, Y)
End; { traitement_droite }

procedure traitement_ctrl_droite;
var sortie : boolean;
    old_lig : integer;
begin
     traitement_droite;
     while not (((x <= length (code_source.lignes [lig])) and (code_source.lignes [lig] [x] <> ' '))
               or ((x >= length (code_source.lignes [code_source.nb_lig])) and (lig = code_source.nb_lig))) do
           traitement_droite;
     {endwhile}
     sortie := false;
     old_lig := lig;
     while not (((x <= length (code_source.lignes [lig])) and (code_source.lignes [lig] [x] = ' '))
               or ((x >= length (code_source.lignes [code_source.nb_lig])) and (lig = code_source.nb_lig))
               or (sortie)) do
           begin
                traitement_droite;
                sortie := ((x = 1)
                          and (length (code_source.lignes [old_lig]) > 0)
                          and (code_source.lignes [old_lig] [length (code_source.lignes [old_lig])] <> ' '));
           end;
     {endwhile}
     if not ((x >= length (code_source.lignes [code_source.nb_lig])) and (lig = code_source.nb_lig))
     then
         begin
              traitement_gauche;
              if (x > length (code_source.lignes [lig]))
              then
                  traitement_gauche;
              {endif}
         end;
     {endif}
end; { traitement_ctrl_droite }

Procedure Traitement_End;
Begin { traitement_end }
  X := min (nb_max_carac, Succ (Length (Code_Source.Lignes [Lig])));
  met_ligne (Lig, Y)
End; { traitement_end }

Procedure Traitement_Gauche;
Begin { traitement_gauche }
  If (X > 1)
  Then
    Dec (X)
  Else
      begin
           traitement_haut;
           traitement_end;
      end;
  {endif}
  met_ligne (Lig, Y)
End; { traitement_gauche }

procedure traitement_ctrl_gauche;
var sortie : boolean;
    old_lig : integer;
begin
     traitement_gauche;
     while not (((x <= length (code_source.lignes [lig])) and (code_source.lignes [lig] [x] <> ' '))
               or ((x = 1) and (lig = 1))) do
           traitement_gauche;
     {endwhile}
     sortie := false;
     old_lig := lig;
     while not (((x <= length (code_source.lignes [lig])) and (code_source.lignes [lig] [x] = ' '))
               or ((x = 1) and (lig = 1))
               or (sortie)) do
           begin
                traitement_gauche;
                sortie := ((x >= length (code_source.lignes [lig]))
                          and (length (code_source.lignes [old_lig]) > 0)
                          and (code_source.lignes [old_lig] [1] <> ' '));
           end;
     {endwhile}
     if not ((x = 1) and (lig = 1))
     then
         traitement_droite;
     {endif}
end; { traitement_ctrl_gauche }

Procedure Traitement_Haut;
Begin { traitement_haut }
  Traite_Ligne;
  If (Y > 1)
  Then
    Begin
      Dec (Lig);
      Dec (Y)
    End
  Else
    If (Lig > 1)
    Then
      Begin
        Y := 1;
        Dec (Lig);
        Num_Ligne_1 := Lig;
        Ins_Line
      End
    {endif}
  {endif};
  met_ligne (Lig, Y);
  If (X > Succ (Length (Code_Source.Lignes [Lig])))
  Then
    X := Succ (Length (Code_Source.Lignes [Lig]))
  {endif}
End; { traitement_haut }

Procedure Traitement_Home;
Begin { traitement_home }
  X := 1;
  met_ligne (Lig, Y)
End; { traitement_home }

Procedure Traitement_Insertion_Caractere (Carac : Char);
Var I : Integer;
Begin { traitement_insertion_caractere }
  If (Carac >= ' ')
  Then
    Begin
      With Code_Source Do
        Begin
          If (Length (Lignes [Lig]) < 66)
          Then
            Begin
{ Traitement du mode d'insertion. }
              If ((Mode_Insert) Or (X > Length (Lignes [Lig])))
              Then
                Begin
                  Lignes [Lig] [0] := Chr (Succ (Ord (Lignes [Lig] [0])));
                  For I := Length (Lignes [Lig]) Downto Succ (X) Do
                    Lignes [Lig] [I] := Lignes [Lig] [Pred (I)]
                  {endfor}
                End
              {endif};
              Lignes [Lig] [X] := Carac;
              Inc (X)
            End
          Else
            Write (Carac_Bell)
          {endif}
        End
      {endwith};
      met_ligne (Lig, Y)
    End
  {endif}
End; { traitement_insertion_caractere }

Procedure Traitement_Page_Dn;
Begin { traitement_page_dn }
  Traite_Ligne;
  If (Num_Ligne_1 + 19 < Succ (Code_Source.Nb_Lig))
  Then
    Begin
      Num_Ligne_1 := Num_Ligne_1 + 19;
      Lig := Lig + 19
    End
  Else
    Begin
      Lig := Code_Source.Nb_Lig;
      Y := Succ (Lig-Num_Ligne_1)
    End
  {endif};
  If (X > Succ (Length (Code_Source.Lignes [Lig])))
  Then
    X := Succ (Length (Code_Source.Lignes [Lig]))
  {endif};
  Affichage_Listing (Num_Ligne_1, Lig)
End; { traitement_page_dn }

procedure traitement_ctrl_page_dn;
begin
     traite_ligne;
     lig := code_source.nb_lig;
     y := min (19, max (1, lig));
     num_ligne_1 := max (1, succ (lig - 19));
     If (X > Succ (Length (Code_Source.Lignes [Lig])))
     Then
         X := Succ (Length (Code_Source.Lignes [Lig]));
     {endif}
     affichage_listing (num_ligne_1, lig);
end; { traitement_ctrl_page_dn }

Procedure Traitement_Page_Up;
Begin { traitement_page_up }
  Traite_Ligne;
  If (Num_Ligne_1 > 19)
  Then
    Begin
      Num_Ligne_1 := Num_Ligne_1 - 19;
      Lig := Lig - 19
    End
  Else
    Begin
      Lig := 1;
      Num_Ligne_1 := 1;
      Y := 1
    End
  {endif};
  If (X > Succ (Length (Code_Source.Lignes [Lig])))
  Then
    X := Succ (Length (Code_Source.Lignes [Lig]))
  {endif};
  Affichage_Listing (Num_Ligne_1, Lig)
End; { traitement_page_up }

procedure traitement_ctrl_page_up;
begin
     traite_ligne;
     lig := 1;
     y := 1;
     num_ligne_1 := 1;
     If (X > Succ (Length (Code_Source.Lignes [Lig])))
     Then
         X := Succ (Length (Code_Source.Lignes [Lig]));
     {endif}
     affichage_listing (num_ligne_1, lig);
end; { traitement_ctrl_page_up }

Procedure Traitement_Return;
Var I, J : Integer;
Begin { traitement_return }
  Traite_Ligne;
  Insere_Ligne;
{ Indentation en fonction du mode choisi. }
  If ((Lig > 1) And (Mode_Indent))
  Then
    Begin
      X := 1;
      While Not ((X > Length (Code_Source.Lignes [Pred (Lig)]))
                Or (Code_Source.Lignes [Pred (Lig)] [X] <> ' ')) Do
        Begin
          Code_Source.Lignes [Lig] [0] := Chr (X);
          Code_Source.Lignes [Lig] [X] := ' ';
          Inc (X)
        End
      {endhwile}
    End
  Else
    X := 1
  {endif};
  If ((X < 1) Or (X > 66))
  Then
    Begin
      Traite_Ligne;
      X := 1
    End
  {endif}
End; { traitement_return }

Procedure Traitement_Tabulation;
Var I, Old_X : Integer;
    Chaine   : String;
Begin { traitement_tabulation }
  Old_X := X;
  If (X < 2)
  Then
    X := 2
  Else
    If (X < 6)
    Then
      X := 6
    Else
      X := ((X + Nb_Col_Tab) Div Nb_Col_Tab) * Nb_Col_Tab
    {endif}
  {endif};
  If ((X > 66) Or (X-Old_X+Length (Code_Source.Lignes [Lig]) > 66))
  Then
    X := Old_X
  {endif};
  Chaine := '';
  For I := Old_X To Pred (X) Do
    Chaine := Concat (Chaine, ' ')
  {endfor};
  With Code_Source Do
    Lignes [Lig] := Concat (Copy (Lignes [Lig], 1, Pred (Old_X)), Concat (Chaine, Copy (Lignes [Lig], Old_X, 66)))
  {endwith};
  met_ligne (Lig, Y)
End; { traitement_tabulation }

End. { Fin de l'unit‚ 'U_Deplacement'. }
