{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}

module Views.Talk (listTalkPage,editTalkPage,newTalkForm,displayTalkPage) where

import Site.Map
import Views.Layout
import Models.Talk
import Text.Hamlet (hamlet,HtmlUrl)
import Text.Blaze.Html.Renderer.String (renderHtml)
import Data.List(intercalate)

formatTalk t = [hamlet|
        <h3>#{title t} (#{show $ duration t} minutes)
        <p>Par: #{speaker t}
        <p>Difficulté: #{difficulty t}
        <p>Status: #{status t}
|]

listTalkPage talks = renderHtml $ layout [hamlet|
<div class="row span12">
    <div class="row span7">
        $forall (t,oId) <- talks
            ^{formatTalk t}
            <a href="/talk/#{show oId}">Edit
    <div class="row span5">
        <h3>Nouveau talk
        ^{newTalkForm}
|] "Liste des talks" render

editTalkPage talks = renderHtml $ layout [hamlet|
<div class="row span12">
    $forall (t,oId) <- talks
        <div class="row span5">
            ^{formatTalk t}
        <div class="row span5">
            ^{updateTalkForm (show oId) t}
|] "Editer un talk" render

displayTalkPage talks = renderHtml $ layout [hamlet|
<div class="row span12">
    $forall (t,oId) <- talks
        ^{formatTalk t}
|] "Talk enregistré" render


newTalkForm = [hamlet|
        <form accept-charset="UTF-8" action="/talk" class="form" id="new_talk" method="post">
            <div>
                <input name="utf8" type="hidden" value="&#x2713;">
            <div>
                <label class="string required" for="talk_speaker">
                    <abbr title="requis">*
                    Nom/Prénom/Pseudo
                <input class="string required" id="talk_speaker" maxlength="255" name="talk[speaker]" placeholder="Anne Onyme" required="required" size="50" type="text">
            <div>
                <label class="string required" for="talk_title">
                    <abbr title="requis">*
                    Titre
                <input class="string required" id="talk_title" maxlength="255" name="talk[title]" placeholder="C'est l'histoire d'un type" required="required" size="50" type="text">
            <div>
                <label class="string required" for="talk_duration">
                    <abbr title="requis">*
                    Durée en minutes (moins de 30)
                <input class="string required" id="talk_duration" maxlength="255" name="talk[duration]" placeholder="20" required="required" size="50" type="text">
            <div>
                <label class="string required" for="talk_difficulty">
                    <abbr title="requis">*
                    Niveau requis
                <input class="string required" id="talk_difficulty" maxlength="255" name="talk[difficulty]" placeholder="Débutant" required="required" size="50" type="text">
            <div>
                <input class="button btn" name="commit" type="submit" value="Envoyer">
|]

updateTalkForm oId talk = [hamlet|
        <form accept-charset="UTF-8" action="/talk/#{oId}" class="form" id="new_talk" method="post">
            <div>
                <input name="utf8" type="hidden" value="&#x2713;">
            <div>
                <label class="string required" for="talk_speaker">
                    <abbr title="requis">*
                    Nom/Prénom/Pseudo
                <input class="string required" id="talk_speaker" maxlength="255" name="talk[speaker]" placeholder="Anne Onyme" required="required" size="50" type="text" value="#{speaker talk}">
            <div>
                <label class="string required" for="talk_title">
                    <abbr title="requis">*
                    Titre
                <input class="string required" id="talk_title" maxlength="255" name="talk[title]" placeholder="C'est l'histoire d'un type" required="required" size="50" type="text" value="#{title talk}">
            <div>
                <label class="string required" for="talk_duration">
                    <abbr title="requis">*
                    Durée en minutes (moins de 30)
                <input class="string required" id="talk_duration" maxlength="255" name="talk[duration]" placeholder="20" required="required" size="50" type="text" value="#{duration talk}">
            <div>
                <label class="string required" for="talk_difficulty">
                    <abbr title="requis">*
                    Niveau requis
                <input class="string required" id="talk_difficulty" maxlength="255" name="talk[difficulty]" placeholder="Débutant" required="required" size="50" type="text" value="#{difficulty talk}">
            <div>
                <label class="string required" for="talk_status">
                    <abbr title="requis">*
                    Statut
                <input class="string required" id="talk_status" required="required" name="talk[status]" type="radio" value="submitted"> submitted
                <input class="string required" id="talk_status" required="required" name="talk[status]" type="radio" value="rejected"> rejected
                <input class="string required" id="talk_status" required="required" name="talk[status]" type="radio" value="scheduled"> scheduled
                <input class="string required" id="talk_status" required="required" name="talk[status]" type="radio" value="presented"> presented
            <div>
                <input class="button btn" name="commit" type="submit" value="Envoyer">
|]