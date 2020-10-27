# Parts (to get voila working on Binder) adapted from:
# https://github.com/danlester/binderhub-voila-native/blob/9cc3b5bac97473184e93689b1d6168b7b53060cf/Dockerfile#L1

# Stack
FROM darribas/gds_py:5.0
RUN pip uninstall -y jupyter-book \
                     myst-nb \
 && pip install \
          jhsingle-native-proxy>=0.0.10 \
          voila \
          voila-material

# File system setup
RUN rm -R work
COPY . ${HOME}
RUN mv index.ipynb Presentation.ipynb

# Permissions
USER root
RUN chown -R ${NB_UID} ${HOME}
RUN chown jovyan ${HOME}/entrypoint.sh \
 && chmod +x ${HOME}/entrypoint.sh
USER ${NB_USER}

# Voila setup
EXPOSE 8888

ENTRYPOINT ["/home/jovyan/entrypoint.sh"]

CMD ["jhsingle-native-proxy", "--destport", "8505", \
     "voila", \
     "--debug", \
     "/home/jovyan/Presentation.ipynb", \
     "{--}template=material", \
     "{--}port={port}", \
     "{--}no-browser", \
     "{--}Voila.base_url={base_url}/", \
     "{--}Voila.server_url=/" \
     ]


