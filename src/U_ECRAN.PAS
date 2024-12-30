Unit U_Ecran;                { Mise … jour le 21/07/1991. }
{
Logiciel: ED_COBOL.

Auteur: Pr‚martin Patrick.
Date: 09/03/1991.
      10/03/1991.
      18/07/1991.
      20/07/1991.
      21/07/1991.

But: Gestion des affichages du listing et de l'‚cran de l'‚diteur.
}
{ $define demo_vers}
Interface

Uses
    Crt,
    U_Aff_Chaine,
    u_curseur,
    U_Date,
    U_Fenetre,
    U_Listing,
    U_Time,
    U_Variables;

Procedure Initialisation_Ecran;
          { Initialisation des variables de cette unit‚. }
Procedure Met_Ligne_Titre (X, Y : Integer);
          { Affiche la ligne de titre de l'‚diteur. }
Procedure Ins_Line;
          { D‚calage de l'‚cran vers le bas d'une ligne. }
Procedure Del_Line;
          { D‚calage de l'‚cran vers le haut d'une ligne. }
Procedure Dessin_Ecran;
          { Dessin de l'‚diteur. }
Procedure met_Ligne (Num_Ligne, Y : Integer);
          { Affichage de la ligne sp‚cifi‚e. }
Procedure Affichage_Listing (Ligne_Haut, Ligne : Integer);
          { Affichage d'un ‚cran du programme … partir de Ligne_Haut. }
Procedure Message_Menu;
          { Affichage de la ligne de menu. }

Implementation
procedure inverse_video;
begin
     textattr := ((textattr and $f0) div $10) + ((textattr and $0f) * $10);
end; { inverse_video }

procedure window_editor;
begin
     window (7, 6, 73, 24);
     Textcolor (c_col_txt_listing);
     Textbackground (c_col_bck_listing);
     clrscr;
end; { window_editor }

Procedure Initialisation_Ecran;
Begin
  Reset_Screen;
  Dessin_Ecran;
  Affichage_Listing (Num_Ligne_1, Lig)
End; { initialisation_ecran }

Procedure Met_Num_Ligne (Num_Ligne : Integer);
Begin
  curseur_locate (24, 4);
  Write ('Lig ', Num_Ligne : 3)
End; { met_num_ligne }

Procedure Met_Num_Colonne (Colonne : Integer);
Begin
  curseur_locate (16, 4);
  Write ('Col ', Colonne : 3)
End; { met_num_colonne }

Procedure Affiche_Mode_Editeur;
Begin
{ Mode d'insertion. }
  curseur_locate (32, 4);
  If (Mode_Insert)
  Then
    Write ('Insert')
  Else
    Write ('      ')
  {endif};
{ Mode d'indentation. }
  curseur_locate (39, 4);
  If (Mode_Indent)
  Then
    Write ('Indent')
  Else
    Write ('      ')
  {endif};
{ Affichage de l'heure. }
  curseur_locate (46, 4);
  If (Mode_Time)
  Then
    Write (Get_Time_Chaine)
  Else
    Write ('        ')
  {endif};
{ Affichage de la date. }
  curseur_locate (55, 4);
  If (Mode_Date)
  Then
    Write (Get_Date_Chaine)
  Else
    Write ('          ')
  {endif}
End; { affiche_mode_editeur }

Procedure Met_Ligne_Titre (X, Y : Integer);
Begin
  Textcolor (c_col_txt_ln_titre);
  Textbackground (c_col_bck_ln_titre_1);
  curseur_locate (7, 4);
  Write ('7');
  Textbackground (c_col_bck_ln_titre_2);
  Write ('A   ');
  Textbackground (c_col_bck_ln_titre_3);
  Write ('B');
  clreol;
  Met_Num_Ligne (Lig);
  Met_Num_Colonne (X + 6);
  Affiche_Mode_Editeur;
End; { met_ligne_titre }

Procedure Ins_Line;
Begin
     Textcolor (c_col_txt_listing);
     Textbackground (c_col_bck_listing);
     Gotoxy (1, Y);
     Insline;
End; { ins_line }

Procedure Del_Line;
Begin
     Textcolor (c_col_txt_listing);
     Textbackground (c_col_bck_listing);
     Gotoxy (1, 1);
     Delline;
End; { del_line }

Procedure Dessin_Ecran;
Begin
  Reset_Screen;
{ partie du menu: en haut de l'ecran }
  Message_Menu;
{ reste de l'ecran }
  Window (1, 4, 80, 25);
  Textbackground (c_col_bordure);
  Clrscr;
{ haut de l'editeur: ligne de l'affichage des colonnes }
  Window_Cadre_Bis (7, 4, 73, 4, c_col_form_cadre, c_col_fond_cadre);
  Met_Ligne_Titre (X, Y);
{ affichage de la ligne du menu }
  Message_Menu;
{ delimitation de l'ecran de travail }
  Window_Cadre_Bis (7, 6, 73, 24, c_col_form_cadre, c_col_fond_cadre);
  Window_Titre ('Listing', c_col_txt_titre_fen, c_col_bck_titre_fen);
  window_editor;
End; { dessin_ecran }

Procedure Met_Ligne (Num_Ligne, Y : Integer);
Begin
     Textcolor (c_col_txt_listing);
     Textbackground (c_col_bck_listing);
     Gotoxy (1, Y);
     if ((num_ligne >= ln_deb_bloc) and (num_ligne <= ln_fin_bloc))
     then
         begin
              inverse_video;
              Write (Code_Source.Lignes [Num_Ligne]);
              clreol;
              inverse_video;
         end
     else
         begin
              Write (Code_Source.Lignes [Num_Ligne]);
              clreol;
         end;
     {endif}
End; { met_ligne }

Procedure Affichage_Listing (Ligne_Haut, Ligne : Integer);
Var
   I : Integer;
Begin
     window_editor;
     I := 1;
     While Not ((Pred (I+Ligne_Haut) > Code_Source.Nb_Lig) Or (I > 19)) Do
           Begin
                Met_Ligne (Pred (I+Ligne_Haut), I);
                Inc (I);
           End;
     {endwhile}
     gotoxy (x, y);
End; { affichage_listing }

Procedure Message_Menu;
Begin
  Type_Cadre := 5;
  Window_Cadre_Bis (2, 2, 79, 2, White, Lightgray);
  Window_Titre ('Options', c_col_txt_titre_men, c_col_bck_titre_men);
  Textbackground (c_col_bck_opt_men);
  Textcolor (c_col_txt_opt_men);
  Clrscr;
  Affic_Center ('F1 Aide F2 Sauver  F3 Charger  F4 Imprimer F5 Nouveau F6 DOS Shell');
  affichage_listing (num_ligne_1, lig);
End; { message_menu }

End. { Fin de l'unit‚ 'U_Ecran'. }
