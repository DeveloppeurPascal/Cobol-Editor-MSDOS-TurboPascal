Unit U_Traitement;           { mise … jour le 21/07/1991. }
{
Logiciel: Ed_Cobol.

Auteur: Pr‚martin Patrick.
Date: 09/03/1991.
      10/03/1991.
      18/07/1991.
      20/07/1991.
      21/07/1991.

But: Traitement de tous les ‚vŠnements touchant … l'‚diteur de Cobol: ED_COBOL.
}
{ $define demo_vers}
Interface

Uses
    Crt,
    u_bloc,
    U_Code_Clavier,
    U_Deplacement,
    U_Disk,
    U_Ecran,
    U_Listing,
    U_Menu,
    U_Utilitaire,
    U_Variables;

Procedure Initialisation;
          { Initialisation des variables. }
Procedure Traitement;
          { Gestion de l'‚diteur de Cobol. }

Implementation

Procedure Initialisation;
Var I : Integer;
Begin
  Message_Alerte ('Initialisation des variables...', False);
  Initialisation_Listing;
  Initialisation_Disk;
  bloc_init;
  Init_Coordonnees
End; { initialisation }

Procedure Traitement;
Var Carac  : Char;
    Sortie,
    New    : Boolean;

  Procedure Traitement_Touches_Etendues (Carac : Char);
  Begin
       Case (Carac) Of
{ Touches de fonction. }
            touche_f1  : infos;
            touche_f2  : sauver;
            touche_f3  : begin
                              charger;
                              bloc_init;
                              init_coordonnees;
            end;
            touche_f4  : impression_listing;
            touche_f5  : new := nouveau;
            touche_f6  : dos_shell;
            Touche_F10 : Mode_Indent := Not Mode_Indent;

{ Touches de d‚placements. }
            Touche_Haut         : Traitement_Haut;
            Touche_Bas          : Traitement_Bas;
            Touche_Gauche       : Traitement_Gauche;
            touche_ctrl_gauche  : traitement_ctrl_gauche;
            Touche_Droite       : Traitement_Droite;
            touche_ctrl_droite  : traitement_ctrl_droite;
            Touche_Page_Up      : Traitement_Page_Up;
            touche_ctrl_page_up : traitement_ctrl_page_up;
            Touche_Page_Dn      : Traitement_Page_Dn;
            touche_ctrl_page_dn : traitement_ctrl_page_dn;
            Touche_Home         : Traitement_Home;
            Touche_End          : Traitement_End;

{ Touches ALT+ . }
            touche_alt_x : sortie := quitter;

{ Autres touches. }
            Touche_Ins : Mode_Insert := Not Mode_Insert;
            Touche_Del : Traitement_Delete;
       End;
  End; { traitement_touches_etendues }

  Procedure Traitement_Touches_Normales (Carac : Char);
  Begin
       Case (Carac) Of
{ Touches CTRL+ . }
            Touche_Ctrl_D    : Mode_Date := Not Mode_Date;
            touche_ctrl_k    : bloc_traitement;
            Touche_Ctrl_T    : Mode_Time := Not Mode_Time;
            Touche_Ctrl_Y    : Suppression_Ligne;

{ Autres touches. }
            Touche_Backspace : Traitement_Backspace;
            Touche_Escape    : Sortie := Quitter;
            Touche_Return    : Traitement_Return;
            Touche_Tab       : Traitement_Tabulation;
       Else
           Traitement_Insertion_Caractere (Carac);
       End;
  End; { traitement_touches_normales }

Begin
  Repeat
    Initialisation_Ecran;
    Init_Coordonnees;
    Sortie := False;
    New    := False;
    Affichage_Listing (1, 1);
    Repeat
      Set_Curseur;
      Carac := Readkey;
      If (Carac = Carac_Nul)
      Then
        Traitement_Touches_Etendues (Readkey)
      Else
        Traitement_Touches_Normales (Carac)
      {endif}
    Until ((Sortie) Or (New));
    If (New)
    Then
      Initialisation
    {endif}
  Until (Sortie)
End; { traitement }

End. { Fin de l'unit‚ 'U_Traitement'. }
