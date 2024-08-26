<!DOCTYPE html>
<html lang="jp">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>phpinfo - PHP<?php echo getVersion();?></title>
</head>
<body>
	<h2>ファイルパス</h2>
	<p><?php echo __FILE__; ?></p>

	<h2>データベース</h2>
	<p><?php
		echo checkConectionDatabe(
			"mysql5.7",
			"root",
			"mysql_root_password"
		);
	?></p>
	<p><?php
		echo checkConectionDatabe(
			"mysql8.0",
			"root",
			"mysql_root_password"
		);
	?></p>

	<h2>メール: <a href="http://127.0.0.1:1080" target="_blank" >mailcatcher</a></h2>
	<p><?php echo checkSendmail(); ?></p>

	<h2>phpinfo</h2>
	<?php phpinfo(); ?>

</body>
</html>

<?php
	/**
	 * PHP のバージョンの取得
	 *
	 * @return str PHP のバージョン
	 */
	function getVersion(){
		$version = explode('.', phpversion());
		return $version[0] . "." . $version[1];
	}

	/**
	 * データベースの接続の確認
	 *
	 * @param int $servername データベースのホスト
 	 * @param int $username ユーザ名
	 * @param int $password パスワード
	 * @return str  データベースの接続の結果
	 */
	function checkConectionDatabe(
		$servername,
		$username,
		$password
	) {
		$conn = new mysqli(
			$servername,
			$username,
			$password
		);

		if ($conn->connect_error) {
			return "<span style=\"color: red;\">失敗: </span>" . $servername . " にアクセスできません。" . $conn->connect_error;
		} else {
			return "<span style=\"color: green;\">成功: </span>" . $servername . " にアクセスできました。";
		}
	}

	/**
	 * メール送信の角煮
	 *
	 * @return str メール送信の結果
	 */
	function checkSendmail() {
		$to = "test@example.com";
		$title = "テスト送信";
		$message = "テスト送信です";
		$headers = "From: test@example.com";

		if(mb_send_mail($to, $title, $message, $headers))
		{
			return "<span style=\"color: green;\">成功: </span>送信できました。";
		} else {
			return "<span style=\"color: red;\">失敗: </span>送信できませんでした。";
		}
	}