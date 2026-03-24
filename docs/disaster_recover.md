<h1> Plano de Recuperação de Desastres (Disaster Recovery) </h1>

<p>
Desastres podem ocorrer por diversos motivos, como falhas em deploy, problemas de hardware ou até mesmo acidentes. Pensando nisso, foi desenvolvido um script em Bash para automatizar o processo de restauração de backups.
</p>


<h2> Funcionamento </h2>

<p> O script recebe como argumento um arquivo de backup criptografado com GPG: </p>

<code>./restore.sh backup.tar.gz.gpg </code>

<p>
Durante a execução, o backup é descriptografado e extraído para um diretório temporário. A partir disso, o processo de restauração é realizado de forma segmentada.
</p>

<h2> Restauração por blocos </h2>

<p> A restauração é organizada em blocos independentes, onde cada função é responsável por um diretório específico do sistema: </p>


<code>/var/www
/home
/root
/opt
/etc
</code>


<p> Cada bloco pode ser ativado ou desativado diretamente na função principal: </p>


<code>main() {
      # var
      # home
      # root
      # opt
      # etc
      rm -rf "$TMP_DIR"
}
</code>


<p> Essa abordagem permite maior controle durante o processo de recuperação, evitando sobrescritas desnecessárias e reduzindo riscos. </p>

<h2> Validação e segurança </h2>


<p> Antes de restaurar os dados, cada bloco realiza validações básicas, como a existência dos diretórios no backup.

Além disso, o uso de criptografia com GPG garante que os dados armazenados estejam protegidos contra acesso não autorizado. </p>

<h2> Logs </h2>

<p>Durante a execução, todas as ações são registradas em um arquivo de log, incluindo: </p>

<ul>
<li>início do processo</li>
<li>etapas executadas</li>
<li>sucesso ou falha de cada operação</li>
</ul>

<p> Isso facilita a auditoria e o diagnóstico de problemas durante a recuperação. </p>

<h2> Considerações </h2>

O script foi desenvolvido com foco em simplicidade e controle manual, sendo ideal para ambientes de estudo (homelab) e cenários de pequeno porte.
