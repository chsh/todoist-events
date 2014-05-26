
# これは何?

このプログラムは、Todoistのイベントカレンダーに、終了時間を付与したカレンダーを生成するためのフィルターです。

Todoistのpremium版ではイベントの情報をMacのCalendarアプリで購読して読めるようになりますが、このカレンダーは、「終日」ないし「開始時間」指定しかできず、前者の場合は1日、後者の場合は1時間のイベントとなります。

このフィルターを使えば、それぞれに対して「終了時間」が設定できるようになります。


# どうやって使うの?

タスクを記述するところに、終了時間を書きます。開始時間を書いてもよいですが無視されます。

例

- 日時設定をしておいて、タイトルを「二時間のタスク (10:00-12:00)」と設定
- 日付設定をしておいて、「かなり長いタスク (3日間) 」というタイトルに
- Long task (3 days)
- half day task (6hours)

ハイフン(-) 終了時間 の部分を認識します。( n (days|hours|mins)) のようにカッコでか括ったところに
数字＋時間単位を書いても認識します。カッコは始まり部分しか見ていませんが、括っておいた方が見やすいかなと思います。

# どうやって設定するの?

herokuでの利用を想定していますが、Rails app なのでデプロイできるところであればどこでも動きます。

## リポジトリをclone

https://github.com/chsh/todoist-events からリポジトリをcloneします。

## herokuにアプリを作成

herokuの基本設定はすでに終わっているものとします。

https://devcenter.heroku.com/articles/creating-apps このあたりを参考に。

リポジトリのディレクトリに移動して、

```shell
heroku create
git push heroku master
```

## 環境変数を設定

- TODOIST_EVENTS_URL TodoistのカレンダーURL
- PRIVATE_TOKEN URLに含めるトークン

## 実行(カレンダーURL)

https://app-name.herokuapp.com/?key=PRIVATE_TOKEN

これをCalendarなどに登録すればOK

# ライセンス

MIT


バグを見つけたらissueでレポートしていただくとうれしいですが、直してpull requestを送っていただければ喜びます。
