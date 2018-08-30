apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: pelias-interpolation
spec:
  replicas: {{ .Values.interpolationReplicas | default 1 }}
  template:
    metadata:
      labels:
        app: pelias-interpolation
    spec:
      {{- if .Values.interpolation.init_containers.enabled }}
      initContainers:
        - name: interpolation-download
          image: busybox
          command: ["sh", "-c",
            "mkdir -p /data/interpolation/ &&\n
             wget -O- https://s3.amazonaws.com/pelias-data.nextzen.org/interpolation/current/street.db.gz | gunzip > /data/interpolation/street.db &\n
             wget -O- https://s3.amazonaws.com/pelias-data.nextzen.org/interpolation/current/address.db.gz | gunzip > /data/interpolation/address.db" ]
          volumeMounts:
            - name: data-volume
              mountPath: /data
          securityContext:
            privileged: {{ .Values.interpolation.security_context.privileged }}
          resources:
            limits:
              memory: 3Gi
              cpu: 2
            requests:
              memory: 512Mi
              cpu: 0.1
      {{- end }}
      containers:
        - name: pelias-interpolation
          image: pelias/interpolation:{{ .Values.interpolationDockerTag | default "latest" }}
          volumeMounts:
            - name: data-volume
              mountPath: /data
          securityContext:
            privileged: {{ .Values.interpolation.security_context.privileged }}
          resources:
            limits:
              memory: 3Gi
              cpu: 2
            requests:
              memory: 2Gi
              cpu: 0.1
      volumes:
      {{- if .Values.interpolation.pvc.enabled }}
        - name: data-volume
          persistentVolumeClaim:
            claimName: {{ .Values.interpolation.pvc.name }}
      {{- else }}
        - name: data-volume
          emptyDir: {}
      {{- end }}
