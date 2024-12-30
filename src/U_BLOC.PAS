unit u_bloc;               { Mise … jour le 20/07/1991. }
{
Logiciel: ED_COBOL.

Auteur: Pr‚martin Patrick.
Date: 20/07/1991.

But: Cette unit‚ gŠre les blocs cr‚‚s par l'‚diteur.
}
{ $define demo_vers}
interface

uses
    crt,
    u_code_clavier,
    u_disk,
    u_ecran,
    u_listing,
    u_utilitaire,
    u_variables;

procedure bloc_init;

procedure bloc_traitement;

procedure bloc_debut;
          { Touches ^KB }

procedure bloc_fin;
          { Touches ^KK }

procedure bloc_deplacement;
          { Touches ^KV }

procedure bloc_copie;
          { Touches ^KC }

procedure bloc_cache;
          { Touches ^KH }

procedure bloc_efface;
          { Touches ^KY }

procedure bloc_sauver;
          { Touches ^KW }

procedure bloc_lire;
          { Touches ^KR }

procedure bloc_imprimer;
          { Touches ^KP }



implementation
var bloc_is : boolean;

procedure swap (var a, b : integer);
var
   c : integer;
begin
     c := a; a := b; b := c;
end; { swap }

procedure bloc_init;
begin
     ln_deb_bloc := 0;
     ln_fin_bloc := 0;
     bloc_is := false;
end; { bloc_init }

procedure bloc_test;
begin
     if (ln_deb_bloc > ln_fin_bloc)
     then
         ln_fin_bloc := ln_deb_bloc;
     {endif}
     if ((ln_deb_bloc < 1) and (ln_fin_bloc > 0))
     then
         ln_deb_bloc := ln_fin_bloc;
     {endif}
     if ((ln_deb_bloc < 0) or (ln_fin_bloc < 0))
     then
         bloc_init;
     {endif}
     if ((ln_deb_bloc > code_source.nb_lig) or (ln_fin_bloc > code_source.nb_lig))
     then
         bloc_init;
     {endif}
end; { bloc_test }

procedure bloc_debut;
begin
     bloc_is := true;
     ln_deb_bloc := lig;
     bloc_test;
end; { bloc_debut }

procedure bloc_fin;
begin
     bloc_is := true;
     ln_fin_bloc := lig;
     bloc_test;
end; { bloc_fin }

procedure bloc_deplacement;
var i : integer;
    larg_bloc : integer;
begin
     if (bloc_is and ((lig < ln_deb_bloc) or (lig > ln_fin_bloc)))
     then
         begin
              larg_bloc := ln_fin_bloc - ln_deb_bloc;
              if (lig < ln_deb_bloc)
              then
                  for i := 1 to succ (larg_bloc) do
                      decal_lig (pred (ln_deb_bloc + i), pred (lig + i))
                  {endfor}
              else
                  begin
                       for i := 1 to succ (larg_bloc) do
                           decal_lig (succ (ln_fin_bloc - i), (lig - i));
                       {endfor}
                       lig := lig - succ (larg_bloc);
                       y := y - succ (larg_bloc);
                       if (lig < num_ligne_1)
                       then
                           begin
                                num_ligne_1 := lig;
                                y := 1;
                           end
                       {endif}
                  end;
              {endif}
              ln_deb_bloc := lig;
              ln_fin_bloc := ln_deb_bloc + larg_bloc;
              bloc_test;
         end;
     {endif}
end; { bloc_deplacement }

procedure bloc_copie;
var ligne : t_ligne;
    i : integer;
    larg_bloc : integer;
begin
     if (bloc_is and ((lig < ln_deb_bloc) or (lig > ln_fin_bloc)))
     then
         begin
              larg_bloc := ln_fin_bloc - ln_deb_bloc;
              if (code_source.nb_lig + succ (larg_bloc) > nb_max_ligne)
              then
                  begin
                       message_alerte ('La copie de ce bloc depasserait le tampon.', false);
                       message_alerte ('Abandon de l''op‚ration.', false);
                  end
              else
                  begin
                       if (lig < ln_deb_bloc)
                       then
                           for i := 1 to succ (larg_bloc) do
                               begin
                                    inc (code_source.nb_lig);
                                    decal_lig (code_source.nb_lig, pred (lig + i));
                                    code_source.lignes [pred (lig + i)] := code_source.lignes [pred (ln_deb_bloc + 2*i)];
                               end
                           {endfor}
                       else
                           for i := 1 to succ (larg_bloc) do
                               begin
                                    inc (code_source.nb_lig);
                                    decal_lig (code_source.nb_lig, pred (lig + i));
                                    code_source.lignes [pred (lig + i)] := code_source.lignes [pred (ln_deb_bloc + i)];
                               end;
                           {endfor}
                       {endif}
                       ln_deb_bloc := lig;
                       ln_fin_bloc := ln_deb_bloc + larg_bloc;
                       bloc_test;
                  end;
              {endif}
         end;
     {endif}
end; { bloc_copie }

procedure bloc_cache;
begin
     bloc_init;
end; { bloc_cache }

procedure bloc_efface;
var larg_bloc : integer;
    i : integer;
begin
     if bloc_is
     then
         begin
              larg_bloc := ln_fin_bloc - ln_deb_bloc;
              for i := 1 to succ (larg_bloc) do
                  begin
                       decal_lig (ln_deb_bloc, code_source.nb_lig);
                       dec (code_source.nb_lig);
                  end;
              {endfor}
              if (lig > ln_deb_bloc)
              then
                  begin
                       lig := lig - succ (larg_bloc);
                       y := y - succ (larg_bloc);
                       if (lig < num_ligne_1)
                       then
                           begin
                                num_ligne_1 := lig;
                                y := 1;
                           end
                       {endif}
                  end;
              {endif}
              bloc_init;
         end;
     {endif}
end; { bloc_efface }

procedure bloc_sauver;
begin
     if bloc_is
     then
         begin
{$IFDEF DEMO_VERS}
              message_alerte ('Version de d‚monstration. Pas de sauvegardes...', true);
{$ELSE}
              swap_file_name;
              Message_Alerte ('Entrez le nom du bloc … sauver.', True);
              Demande_Nom_Fichier ('Sauvegarde du bloc :');
              Sauvegarde_bloc;
              swap_file_name;
{$ENDIF}
              Initialisation_Ecran;
         end;
     {endif}
end; { bloc_sauver }

procedure bloc_lire;
var
   larg_bloc : integer;
begin
     swap_file_name;
     Message_Alerte ('Nom du bloc … charger.', True);
     Demande_Nom_Fichier ('Chargement du bloc: ');
     bloc_debut;
     Chargement_bloc;
     bloc_fin;
     swap_file_name;
     lig := ln_deb_bloc;
     initialisation_ecran;
end; { bloc_lire }

procedure bloc_imprimer;
begin
     if bloc_is
     then
         begin
              If (Question_Alerte ('Voulez-vous imprimer ce bloc ?'))
              Then
                  Impression_bloc;
              {endif}
              Message_Menu;
         end;
     {endif}
end; { bloc_imprimer }

procedure bloc_traitement;
var
   carac : char;
begin
     carac := upcase (readkey);
     case carac of
          'B',
          touche_ctrl_b : bloc_debut;
          'K',
          touche_ctrl_k : bloc_fin;
          'V',
          touche_ctrl_v : bloc_deplacement;
          'C',
          touche_ctrl_c : bloc_copie;
          'H',
          touche_ctrl_h : bloc_cache;
          'Y',
          touche_ctrl_y : bloc_efface;
          'W',
          touche_ctrl_w : bloc_sauver;
          'R',
          touche_ctrl_r : bloc_lire;
          'P',
          touche_ctrl_p : bloc_imprimer;
     end;
     affichage_listing (num_ligne_1, lig);
     while keypressed do
           carac := readkey;
     {endwhile}
end; { bloc_traitement }

begin
     bloc_init;
end. { Fin de l'unit‚ 'U_Bloc'.}
