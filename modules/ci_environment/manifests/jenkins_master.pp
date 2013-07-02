#Class to install things only on the Jenkins Master
class ci_environment::jenkins_master {
    Package <| title == 'jenkins' |> -> Jenkins::Plugin <| |>
}
