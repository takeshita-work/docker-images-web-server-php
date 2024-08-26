try {
    # 設定ファイルの読み込み
    . $PSScriptRoot/../__config.ps1  # repository setting
    . $PSScriptRoot/__config.ps1        # distribution setting

    # タグ の生成
    $imageTagLatest = "${global:repositoryName}:${global:softwareName}"
    $imageTagDate   = "${global:repositoryName}:${global:softwareName}_${global:date}"

    # Dockerfile のパスの生成
    $dockerfilePath = "./dockerfile/${global:softwareName}/Dockerfile"

    # 生成値の出力
    echo $imageTagLatest
    echo $imageTagDate
    echo $dockerfilePath

    # ビルドの実行
    docker build --no-cache `
        -f $dockerfilePath `
        -t $imageTagLatest `
        -t $imageTagDate `
        .
} catch {
    echo "Error: $_"
    exit 1
}
